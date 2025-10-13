import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/dimens.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  const AppWrapper({super.key, required this.child, this.scrollable = false});

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.screenMarginHorizontal,
            vertical: Dimens.screenMarginVertical,
          ),
          child: scrollable ? SingleChildScrollView(child: child) : child,
        ),
      ),
    );

    return Scaffold(body: content);
  }
}

// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../core/constants/app_dimens.dart';
// import '../../core/theme/app_colors.dart';

// class AppWrapper extends StatelessWidget {
//   final PreferredSizeWidget? appBar;
//   final Widget child;
//   final Widget? bottomNavigationBar;
//   final Widget? bottomSheet;
//   final Widget? floatingActionButton;
//   final EdgeInsets? padding;
//   final Color? backgroundColor;
//   final bool safeAreaBottom;

//   const AppWrapper({
//     super.key,
//     required this.child,
//     this.appBar,
//     this.bottomNavigationBar,
//     this.bottomSheet,
//     this.floatingActionButton,
//     this.padding,
//     this.backgroundColor,
//     this.safeAreaBottom = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar,
//       backgroundColor:
//           backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
//       bottomNavigationBar: bottomNavigationBar,
//       bottomSheet: bottomSheet,
//       floatingActionButton: floatingActionButton,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: SafeArea(
//         bottom: safeAreaBottom,
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight: constraints.maxHeight,
//                   ),
//                   child: IntrinsicHeight(
//                     child: Container(
//                       padding: padding ??
//                           EdgeInsets.symmetric(
//                             horizontal: AppDimen.horizontalPadding.w,
//                             vertical: AppDimen.verticalPadding.h,
//                           ),
//                       color: AppColors.white,
//                       child: child,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
