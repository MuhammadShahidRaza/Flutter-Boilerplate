import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/extensions/localization.dart';
import 'package:sanam_laundry/core/extensions/theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final TextStyle? style;
  final Map<String, String>? params;
  final VoidCallback? onTap;

  const AppText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.letterSpacing,
    this.fontStyle,
    this.style,
    this.params,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = context.textTheme.bodyMedium;

    final textStyle = (defaultStyle?.merge(style))?.copyWith(
      color: color ?? style?.color ?? defaultStyle?.color,
      fontSize: fontSize ?? style?.fontSize ?? defaultStyle?.fontSize,
      fontWeight: fontWeight ?? style?.fontWeight ?? defaultStyle?.fontWeight,
      letterSpacing:
          letterSpacing ?? style?.letterSpacing ?? defaultStyle?.letterSpacing,
      fontStyle: fontStyle ?? style?.fontStyle ?? defaultStyle?.fontStyle,
    );

    Widget textWidget = Text(
      context.tr(text, params: params),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: textStyle,
    );

    if (onTap != null) {
      textWidget = GestureDetector(onTap: onTap, child: textWidget);
    }

    return textWidget;
  }
}
