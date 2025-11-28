## Notifications

This app uses Firebase Cloud Messaging (FCM) + `flutter_local_notifications` to display notifications consistently across foreground, background, and terminated states.

- Foreground: FCM messages are rendered as local notifications so users still see alerts.
- Background: Taps are handled via `FirebaseMessaging.onMessageOpenedApp`.
- Terminated: Pending notification that launched the app is handled via `getInitialMessage()`.

### Setup
- Android: Ensure a monochrome icon `ic_notification` exists at `android/app/src/main/res/drawable/ic_notification.png`.
	- Recommended: 24dp white glyph on transparent background.
- iOS: Enable Push Notifications + Background Modes (Remote notifications) in Xcode, and configure APNs in Firebase.

### Customization
- Change accent color by editing `color` in `NotificationDetails.android` in `lib/core/notifications/notification_service.dart`.
- Update the notification channel name/description in `_defaultAndroidChannel`.
- Provide custom sounds per platform by editing `DarwinNotificationDetails.sound` and Android channel sound in manifest if needed.

### Testing
1. Send a notification from Firebase Console (include both `notification` and `data`).
2. Validate behaviors:
	 - App in foreground: banner appears via local notification.
	 - App in background: tapping opens app and logs the message.
	 - App terminated: tapping launches app; initial message is processed.

### Deep Links
If your payload includes a route (e.g., `data: { route: "/orders/123" }`), we can navigate on tap. Share your route schema and we will wire navigation into `NotificationService._handleNotificationTapPayload`.

# sanam_laundry

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
