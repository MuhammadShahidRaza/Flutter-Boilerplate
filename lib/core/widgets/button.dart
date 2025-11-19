import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';

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
  final double? width;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  /// Scope is now optional and defaults to "local"
  /// so it won’t affect global loader unless specified manually.
  final String scope;

  /// Optional loader key for fine-grained control
  final String? loaderKey;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.type = AppButtonType.elevated,
    this.isLoading = false,
    this.icon,
    this.style,
    this.isEnabled = true,
    this.width,
    this.textStyle,
    this.padding,
    this.iconStyle,
    this.backgroundColor,
    this.scope = "local", // ✅ changed from "global" to "local"
    this.loaderKey,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Automatically generate unique loader key per button
    // final effectiveKey =
    //     loaderKey ?? LoaderKeyGenerator.generate(scope: scope, title: title);

    final effectiveKey =
        loaderKey ?? 'loader.${title.toLowerCase().replaceAll(' ', '_')}';

    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: LoaderService.instance.scopedCounters,
      builder: (context, counters, _) {
        // ✅ Scoped loader only triggers if this key’s counter > 0
        final scopedLoading = (counters[effectiveKey] ?? 0) > 0;

        return _ButtonBody(
          title: title,
          onPressed: onPressed,
          type: type,
          isLoading: isLoading || scopedLoading,
          icon: icon,
          style: style,
          isEnabled: isEnabled,
          width: width,
          textStyle: textStyle,
          padding: padding,
          iconStyle: iconStyle,
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({
    required this.title,
    required this.onPressed,
    required this.type,
    required this.isLoading,
    this.icon,
    this.style,
    this.textStyle,
    this.iconStyle,
    this.width,
    required this.isEnabled,
    this.padding,
    this.backgroundColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextStyle? iconStyle;
  final double? width;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveOnPressed = (!isEnabled || isLoading) ? null : onPressed;

    final background =
        backgroundColor ??
        (type == AppButtonType.elevated
            ? (isEnabled ? theme.colorScheme.primary : theme.disabledColor)
            : null);

    final defaultButtonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(width ?? context.w(0.65), Dimens.buttonHeight),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusS),
        ),
      ),
      padding: WidgetStatePropertyAll(padding),
      backgroundColor: background != null
          ? WidgetStatePropertyAll(background)
          : null,
    );

    final buttonStyle = style == null
        ? defaultButtonStyle
        : style!.merge(defaultButtonStyle);

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

    // ✅ Button content
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
              Flexible(
                child: AppText(
                  title,
                  style: (textStyle ?? theme.textTheme.bodyLarge)?.copyWith(
                    color: textStyle?.color ?? textColor,
                    fontWeight: textStyle?.fontWeight ?? FontWeight.bold,
                  ),
                ),
              ),
            ],
          );

    switch (type) {
      case AppButtonType.elevated:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: buttonChild,
        );
    }
  }
}
