import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Padding(
          padding: padding ?? EdgeInsets.all(size * 0.25),
          child: iconWidget,
        ),
      );
    }

    return Padding(padding: padding ?? EdgeInsets.zero, child: iconWidget);
  }
}
