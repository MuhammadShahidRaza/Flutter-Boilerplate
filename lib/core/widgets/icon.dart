// import 'package:flutter/material.dart';
// // import 'package:cached_network_image/cached_network_image.dart';

// class AppIcon extends StatelessWidget {
//   final String? path; // asset or network
//   final IconData? icon; // for Material icons
//   final double size;
//   final BoxFit fit;
//   final Color? color;
//   final bool isAsset;
//   final Widget? placeholder;
//   final Widget? errorWidget;

//   const AppIcon({
//     super.key,
//     this.path,
//     this.icon,
//     this.size = 24,
//     this.fit = BoxFit.contain,
//     this.color,
//     this.isAsset = false,
//     this.placeholder,
//     this.errorWidget,
//   }) : assert(path != null || icon != null,
//               'Either path or icon must be provided');

//   @override
//   Widget build(BuildContext context) {
//     // If Material Icon
//     if (icon != null) {
//       return Icon(
//         icon,
//         size: size,
//         color: color,
//       );
//     }

//     // If Asset image
//     if (isAsset) {
//       return Image.asset(
//         path!,
//         width: size,
//         height: size,
//         fit: fit,
//         color: color,
//         errorBuilder: (_, __, ___) =>
//             errorWidget ?? const Icon(Icons.broken_image),
//       );
//     }

//     // If Network image (cached)
//     return CachedNetworkImage(
//       imageUrl: path!,
//       width: size,
//       height: size,
//       fit: fit,
//       color: color,
//       placeholder: (_, __) =>
//           placeholder ?? const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//       errorWidget: (_, __, ___) =>
//           errorWidget ?? const Icon(Icons.broken_image),
//     );
//   }
// }
