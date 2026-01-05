import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool isEnabledButton;
  final bool dismissible;
  final EdgeInsets? insetPadding;
  final EdgeInsetsGeometry? contentPadding;
  final double? spacing;
  final Color? backgroundColor;
  final double? borderRadius;
  final TextStyle? titleStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment buttonAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final String? imagePath;
  final double borderWidth;
  final double? imageSize;
  final Color borderColor;
  final bool showTwoPrimaryButtons;
  final bool isLoading;

  final BoxFit imageFit;
  final Widget? headerWidget;

  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.insetPadding,
    this.dismissible = true,
    this.isEnabledButton = true,
    this.isLoading = false,
    this.contentPadding,
    this.spacing,
    this.backgroundColor,
    this.borderRadius,
    this.titleStyle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.buttonAlignment = MainAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.imagePath,
    this.imageSize,
    this.imageFit = BoxFit.contain,
    this.headerWidget,
    this.borderWidth = 0,
    this.showTwoPrimaryButtons = false,
    this.borderColor = AppColors.transparent,
  });

  static Future<void> show(
    BuildContext context, {
    String? title,
    required Widget content,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    bool isEnabledButton = true,
    bool dismissible = true,
    bool showTwoPrimaryButtons = false,
    EdgeInsets? insetPadding,
    EdgeInsetsGeometry? contentPadding,
    double? spacing,
    Color? backgroundColor,
    double? borderRadius,
    TextStyle? titleStyle,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisAlignment buttonAlignment = MainAxisAlignment.center,
    String? imagePath,
    double borderWidth = 0,
    Color borderColor = AppColors.transparent,
    bool isLoading = false,
    double? imageSize,
    BoxFit imageFit = BoxFit.contain,
    Widget? headerWidget,
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
        isEnabledButton: isEnabledButton,
        dismissible: dismissible,
        insetPadding: insetPadding,
        contentPadding: contentPadding,
        spacing: spacing,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        titleStyle: titleStyle,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        buttonAlignment: buttonAlignment,
        imagePath: imagePath,
        imageSize: imageSize,
        imageFit: imageFit,
        headerWidget: headerWidget,
        borderWidth: borderWidth,
        borderColor: borderColor,
        isLoading: isLoading,
        showTwoPrimaryButtons: showTwoPrimaryButtons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle =
        titleStyle ??
        context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

    final effectiveRadius = borderRadius ?? Dimens.radiusM;

    return PopScope(
      // Prevent native back/gesture dismiss when `dismissible` is false.
      canPop: dismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          side: BorderSide(width: borderWidth, color: borderColor),
        ),
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        insetPadding: insetPadding ?? const EdgeInsets.all(Dimens.spacingM),
        child: Padding(
          padding:
              contentPadding ??
              const EdgeInsets.all(Dimens.screenMarginHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            spacing: spacing ?? Dimens.spacingMLarge,
            children: [
              if (headerWidget != null)
                headerWidget!
              else if (imagePath != null)
                AppImage(
                  path: imagePath!,
                  height: imageSize ?? 80,
                  width: imageSize ?? 80,
                  fit: imageFit,
                ),

              // Title
              if (title != null) AppText(title!, style: effectiveTitleStyle),
              // Content
              Flexible(child: SingleChildScrollView(child: content)),

              if (primaryButtonText != null || secondaryButtonText != null)
                Row(
                  mainAxisAlignment: buttonAlignment,
                  spacing: Dimens.spacingS,
                  children: [
                    if (secondaryButtonText != null)
                      Expanded(
                        child: AppButton(
                          backgroundColor: showTwoPrimaryButtons
                              ? AppColors.darkBlackOpacity
                              : null,
                          isEnabled: isEnabledButton,
                          title: secondaryButtonText!,
                          type: showTwoPrimaryButtons
                              ? AppButtonType.elevated
                              : AppButtonType.text,
                          onPressed:
                              onSecondaryPressed ??
                              () => Navigator.pop(context),
                        ),
                      ),

                    if (primaryButtonText != null)
                      Expanded(
                        child: AppButton(
                          isEnabled: isEnabledButton,
                          title: primaryButtonText!,
                          isLoading: isLoading,
                          type: AppButtonType.elevated,
                          onPressed:
                              onPrimaryPressed ?? () => Navigator.pop(context),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
