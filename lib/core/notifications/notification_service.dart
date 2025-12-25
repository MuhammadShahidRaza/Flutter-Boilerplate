import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _defaultAndroidChannel =
      AndroidNotificationChannel(
        'default_channel',
        'General Notifications',
        description: 'Default channel for app notifications',
        importance: Importance.high,
      );

  Future<void> initialize() async {
    // Request permissions (iOS/macOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // // Set foreground presentation for iOS/macOS
    // await _messaging.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // Configure local notifications
    // Use a monochrome, transparent-background icon for best results
    // Provide `@drawable/ic_notification` if available; fallback to app icon
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle taps on local notifications
        _handleNotificationTapPayload(response.payload);
      },
    );

    // Android 13+ runtime notification permission
    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      if (areEnabled != true) {
        await androidPlugin.requestNotificationsPermission();
      }
    }

    // Create Android channel
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_defaultAndroidChannel);

    // Token (optional: use for logging or backend registration)
    // final token = await _messaging.getToken();
    // debugPrint('FCM token: $token');

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Opened from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground FCM: ${message.messageId}');
    final context = GoRouterSetup.navigatorKey.currentContext;

    if (context != null) {
      context.read<UserProvider>().updateNotificationCount();
    }
    await _showLocalNotificationFromRemoteMessage(message);
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    debugPrint('Notification tap: ${message.messageId}');
    // Navigate or handle deep-link here if needed
    // For now just log; payload contains data.
  }

  Future<void> _showLocalNotificationFromRemoteMessage(
    RemoteMessage message,
  ) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = notification?.android;

    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    final String payload = jsonEncode({
      'messageId': message.messageId,
      'data': message.data,
      'title': title,
      'body': body,
    });

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _defaultAndroidChannel.id,
        _defaultAndroidChannel.name,
        channelDescription: _defaultAndroidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: android?.smallIcon ?? '@drawable/ic_notification',
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        color: const Color(0xFF0F9D58), // brand/primary color for icon accent
        category: AndroidNotificationCategory.message,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.active,
      ),
    );

    await _local.show(
      message.messageId.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _handleNotificationTapPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint('Tapped notification payload: $map');
      // Implement navigation/deeplink using payload if needed.
    } catch (e) {
      debugPrint('Failed to parse notification payload: $e');
    }
  }
}
