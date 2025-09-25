import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isAsset;

  const AppImage({
    super.key,
    required this.path,
    this.width = 20,
    this.height = 20,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.isAsset = false, // if true → load from assets, else network
  });

  @override
  Widget build(BuildContext context) {
    if (isAsset) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const Icon(Icons.broken_image),
      );
    }

    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
      },
      errorBuilder: (_, __, ___) =>
          errorWidget ?? const Icon(Icons.broken_image),
    );
  }
}
