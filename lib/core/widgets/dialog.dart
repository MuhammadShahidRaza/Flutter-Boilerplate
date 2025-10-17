import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool isEnabledButton;
  final bool dismissible;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.dismissible = true,
    this.isEnabledButton = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Widget content,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    bool dismissible = true,
    bool isEnabledButton = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => AppDialog(
        title: title,
        content: content,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        secondaryButtonText: secondaryButtonText,
        onSecondaryPressed: onSecondaryPressed,
        dismissible: dismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
      ),
      insetPadding: const EdgeInsets.all(Dimens.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.screenMarginHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.spacingMLarge,
          children: [
            // Title
            AppText(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            // Scrollable content
            Flexible(child: SingleChildScrollView(child: content)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryButtonText != null)
                  AppButton(
                    isEnabled: isEnabledButton,
                    type: AppButtonType.text,
                    onPressed:
                        onSecondaryPressed ?? () => Navigator.pop(context),
                    title: secondaryButtonText!,
                  ),
                if (primaryButtonText != null)
                  AppButton(
                    isEnabled: isEnabledButton,
                    title: primaryButtonText!,
                    onPressed: onPrimaryPressed ?? () => Navigator.pop(context),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
