// import 'package:flutter/widgets.dart';

// /// Responsive dimension helper
// class Dimens {
//   Dimens._(); // private constructor

//   /// Screen width
//   static double screenWidth(BuildContext context) =>
//       MediaQuery.of(context).size.width;

//   /// Screen height
//   static double screenHeight(BuildContext context) =>
//       MediaQuery.of(context).size.height;

//   /// Dynamic width based on percentage
//   static double w(BuildContext context, double percent) =>
//       screenWidth(context) * percent;

//   /// Dynamic height based on percentage
//   static double h(BuildContext context, double percent) =>
//       screenHeight(context) * percent;

//   /// Example fixed spacing values
//   static const double spacingSmall = 8.0;
//   static const double spacingMedium = 16.0;
//   static const double spacingLarge = 24.0;
// }

import 'package:flutter/widgets.dart';

extension ContextDimens on BuildContext {
  /// Screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Dynamic width based on percentage
  double w(double percent) => screenWidth * percent;

  /// Dynamic height based on percentage
  double h(double percent) => screenHeight * percent;
}
