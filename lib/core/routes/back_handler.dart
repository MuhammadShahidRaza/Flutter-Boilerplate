import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/index.dart';

class AppBackHandler {
  static bool _isAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;

  static bool isAuthLocation(GoRouter router) {
    final path = router.routeInformationProvider.value.uri.path;
    return path == AppRoutes.splash ||
        path == AppRoutes.onboarding ||
        path == AppRoutes.getStarted ||
        path == AppRoutes.login ||
        path == AppRoutes.signUp ||
        path == AppRoutes.verification;
  }

  static Future<bool> confirmExit(BuildContext ctx) async {
    final result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (dCtx) => AlertDialog(
        title: const AppText(Common.exitApp),
        content: const AppText(Common.exitAppConfirmation),
        actions: [
          AppButton(
            type: AppButtonType.text,
            onPressed: () => Navigator.of(dCtx).pop(false),
            title: Common.cancel,
          ),
          AppButton(
            type: AppButtonType.text,
            onPressed: () => Navigator.of(dCtx).pop(true),
            title: Common.exit,
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Handle back press across the app.
  /// - If [shell] is provided (tabbed pages): pop inner routes, else switch to first tab, else confirm exit (Android only).
  /// - If [shell] is null (auth pages): only show exit confirmation when at app root.
  static Future<void> handleBack(
    BuildContext context, {
    StatefulNavigationShell? shell,
  }) async {
    // When inside the tab shell, handle branch navigation first.
    if (shell != null) {
      final canPopBranch = Navigator.of(context).canPop();
      if (canPopBranch) {
        await Navigator.of(context).maybePop();
        return;
      }

      if (shell.currentIndex != 0) {
        shell.goBranch(0, initialLocation: false);
        return;
      }

      final isAndroid = _isAndroid(context);
      final ok = await confirmExit(context);
      if (ok && isAndroid) SystemNavigator.pop();
      return;
    }

    // Outside the shell: only act at auth locations.
    final router = GoRouterSetup.router;
    if (!isAuthLocation(router)) return;

    final rootCanPop =
        GoRouterSetup.navigatorKey.currentState?.canPop() ?? false;
    if (rootCanPop) {
      await GoRouterSetup.navigatorKey.currentState?.maybePop();
      return;
    }

    final isAndroid = _isAndroid(context);
    final ok = await confirmExit(context);
    if (ok && isAndroid) SystemNavigator.pop();
  }
}
