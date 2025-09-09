import 'package:flutter/material.dart';
import 'package:sanam_laundry/l10n/context_extension.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    // Merge defaultStyle + parameters + optional style
    final textStyle = defaultStyle
        ?.copyWith(
          color: color ?? defaultStyle.color,
          fontSize: fontSize ?? defaultStyle.fontSize,
          fontWeight: fontWeight ?? defaultStyle.fontWeight,
          letterSpacing: letterSpacing ?? defaultStyle.letterSpacing,
          fontStyle: fontStyle ?? defaultStyle.fontStyle,
        )
        .merge(style);

    return Text(
      context.tr(text, params: params),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: textStyle,
    );
  }
}
