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

    await _launch(uri, mode: LaunchMode.platformDefault);
  }

  /// Open phone dialer
  static Future<void> openPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone.trim());
    await _launch(uri, mode: LaunchMode.platformDefault);
  }

  /// Open external link (https, http)
  static Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);
    await _launch(uri, mode: LaunchMode.externalApplication);
  }

  /// Open WhatsApp (optional but useful)
  static Future<void> openWhatsApp(String phone, {String? message}) async {
    final Uri uri = Uri.parse(
      'https://wa.me/$phone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );

    await _launch(uri, mode: LaunchMode.externalApplication);
  }

  /// Internal launcher
  static Future<void> _launch(Uri uri, {LaunchMode? mode}) async {
    try {
      if (!await canLaunchUrl(uri)) {
        debugPrint('Could not launch: $uri');
        return;
      }
      await launchUrl(uri, mode: mode ?? LaunchMode.platformDefault);
    } catch (e) {
      debugPrint('Launch error: $e');
    }
  }
}
