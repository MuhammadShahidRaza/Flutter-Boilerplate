import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppToast {
  AppToast._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showToast(
    String message, {
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (message.trim().isEmpty) return;

    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(Dimens.spacingMLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusS),
          ),
          backgroundColor: AppColors.transparent,
          // backgroundColor: isError ? AppColors.error : AppColors.primary,
          // content: AppText(
          //   message,
          //   style: const TextStyle(color: Colors.white),
          // ),
          content: _ToastContent(message: message, isError: isError),
          duration: duration,
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  final String message;
  final bool isError;

  const _ToastContent({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final Color startColor = isError ? AppColors.darkRed : AppColors.primary;
    final Color endColor = isError ? AppColors.error : AppColors.secondary;
    final IconData icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(Dimens.radiusS),
          boxShadow: [
            BoxShadow(
              color: endColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          spacing: Dimens.spacingMSmall,
          children: [
            AppIcon(icon: icon, color: Colors.white, size: Dimens.iconM),
            Expanded(
              child: AppText(
                message,
                maxLines: 3,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: isError ? FontWeight.w500 : FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
