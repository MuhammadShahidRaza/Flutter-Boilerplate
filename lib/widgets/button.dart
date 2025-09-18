import 'package:flutter/material.dart';
import 'package:sanam_laundry/widgets/text.dart';

enum AppButtonType { elevated, outlined, text }

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextStyle? iconStyle;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.type = AppButtonType.elevated,
    this.isLoading = false,
    this.icon,
    this.style,
    this.textStyle,
    this.iconStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ).merge(style);

    // Decide default colors based on button type
    Color textColor;
    Color iconColor;
    switch (type) {
      case AppButtonType.elevated:
        textColor = theme.colorScheme.onPrimary;
        iconColor = theme.colorScheme.onPrimary;
        break;
      case AppButtonType.outlined:
        textColor = theme.colorScheme.primary;
        iconColor = theme.colorScheme.primary;
        break;
      case AppButtonType.text:
        textColor = theme.colorScheme.primary;
        iconColor = theme.colorScheme.primary;
        break;
    }

    // Button content
    final buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: iconStyle?.fontSize ?? theme.iconTheme.size,
                  color: iconStyle?.color ?? iconColor,
                ),
              if (icon != null) const SizedBox(width: 8),
              AppText(
                title,
                style: (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                  color: textColor,
                ),
              ),
            ],
          );

    // Return proper button type with theme defaults + optional custom style
    switch (type) {
      case AppButtonType.elevated:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );

      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
    }
  }
}
