import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/providers/index.dart';

/// Centralized logout that clears auth storage and resets app/user providers.
/// Usage: await performLogout(context);
Future<void> clearSession(BuildContext context) async {
  // Capture provider refs BEFORE awaiting to avoid context-after-await lint
  final auth = context.read<AuthProvider>();
  final user = context.read<UserProvider>();
  final service = context.read<ServicesProvider>();
  final cart = context.read<CartProvider>();
  final loader = context.read<LoaderProvider>();

  // Optional: show a loader while logging out
  loader.show();

  try {
    // 1) Clear auth/token + persisted user
    await auth.logout();

    // 2) Reset user-related provider state
    user.clear();
    service.clear();
    cart.clearOrder();

    // If you add more providers (cart, orders, etc.), clear them here too.
  } finally {
    loader.hide();
  }
}
