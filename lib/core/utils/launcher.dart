import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  AppLauncher._(); // private constructor

  /// Open email app
  static Future<void> openEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    await _launch(uri);
  }

  /// Open phone dialer
  static Future<void> openPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);

    await _launch(uri);
  }

  /// Open external link (https, http)
  static Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);
    await _launch(uri);
  }

  /// Open WhatsApp (optional but useful)
  static Future<void> openWhatsApp(String phone, {String? message}) async {
    final Uri uri = Uri.parse(
      'https://wa.me/$phone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );

    await _launch(uri);
  }

  /// Internal launcher
  static Future<void> _launch(Uri uri) async {
    try {
      if (!await canLaunchUrl(uri)) {
        debugPrint('Could not launch: $uri');
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Launch error: $e');
    }
  }
}
