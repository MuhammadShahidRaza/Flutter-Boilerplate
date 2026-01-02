import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sanam_laundry/core/index.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool isCircular;

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
    this.borderRadius,
    this.isCircular = false,
  });

  bool get _isLocalFile {
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  bool get _isAssetPath => path.startsWith('assets/');

  Widget _applyShape(Widget child) {
    if (isCircular) {
      return ClipOval(child: child);
    }
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: child,
      );
    }
    return child;
  }

  Widget _applySkeletonShape(Widget child) {
    if (isCircular) {
      return ClipOval(child: child);
    }
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: child,
      );
    }
    return child;
  }

  Widget _buildShimmer(BuildContext context) {
    final theme = Theme.of(context);

    final hsl = HSLColor.fromColor(theme.colorScheme.surfaceContainerHighest);
    final highlightDelta = theme.brightness == Brightness.dark ? 0.10 : 0.06;
    final baseDelta = theme.brightness == Brightness.dark ? 0.06 : 0.04;

    final baseColor = hsl
        .withLightness((hsl.lightness - baseDelta).clamp(0.0, 1.0))
        .toColor();
    final highlightColor = hsl
        .withLightness((hsl.lightness + highlightDelta).clamp(0.0, 1.0))
        .toColor();

    return _applySkeletonShape(
      Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(width: width, height: height, color: baseColor),
      ),
    );
  }

  Widget buildPlaceholder() {
    return Image.asset(AppAssets.user, width: width, height: height, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (_isAssetPath) {
      // 🟢 Asset image
      image = _applyShape(
        Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (_, __, ___) => errorWidget ?? buildPlaceholder(),
        ),
      );
    } else if (_isLocalFile) {
      // 🟢 File image
      image = _applyShape(
        Image.file(
          File(path),
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (_, __, ___) => errorWidget ?? buildPlaceholder(),
        ),
      );
    } else if (path.isNotEmpty) {
      image = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return _applyShape(child);
          if (frame == null) return _buildShimmer(context);
          return _applyShape(child);
        },
        errorBuilder: (_, __, ___) =>
            _applyShape(errorWidget ?? buildPlaceholder()),
      );
    } else {
      image = _applyShape(errorWidget ?? buildPlaceholder());
    }

    if (onTap != null) {
      image = InkWell(onTap: onTap, child: image);
    }
    return image;
  }
}
