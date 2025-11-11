import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderWidth;
  final Color? borderColor;

  const AppIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? size / 2);

    final iconWidget = Icon(
      icon,
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );

    Widget content = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: radius,

      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: radius,
            border: (borderWidth != null && borderColor != null)
                ? Border.all(color: borderColor!, width: borderWidth!)
                : null,
          ),
          child: iconWidget,
        ),
      ),
    );

    return content;
  }
}
