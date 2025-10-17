import 'dart:io';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;

  const AppImage({
    super.key,
    required this.path,
    this.width = 20,
    this.height = 20,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.onTap,
  });

  bool get _isLocalFile {
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  bool get _isAssetPath => path.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (_isAssetPath) {
      // 🟢 Asset image
      image = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const Icon(Icons.broken_image),
      );
    } else if (_isLocalFile) {
      // 🟢 File image
      image = Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const Icon(Icons.broken_image),
      );
    } else {
      // 🟢 Network image
      image = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return placeholder ??
              Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              (progress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
        },
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const Icon(Icons.broken_image),
      );
    }

    if (onTap != null) {
      image = GestureDetector(onTap: onTap, child: image);
    }

    return image;
  }
}
