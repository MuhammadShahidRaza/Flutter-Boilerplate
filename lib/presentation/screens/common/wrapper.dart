import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  // final Future<bool> Function()? onWillPop;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? heading;
  final Color? backgroundColor;

  const AppWrapper({
    super.key,
    required this.child,
    this.scrollable = false,
    this.padding,
    this.safeArea = true,
    // this.onWillPop,
    this.showBackButton = false,
    this.onBackPressed,
    this.heading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PreferredSizeWidget? appBar;

    Widget content = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: Dimens.screenMarginHorizontal,
              vertical: Dimens.screenMarginVertical,
            ),
        child: scrollable ? SingleChildScrollView(child: child) : child,
      ),
    );

    if (safeArea) {
      content = SafeArea(bottom: false, child: content);
    }

    // // 🔙 Handle hardware back press
    // content = WillPopScope(
    //   onWillPop:
    //       onWillPop ??
    //       () async {
    //         return true;
    //       },
    //   child: content,
    // );

    if (showBackButton || heading != null) {
      appBar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
        leading: showBackButton
            ? Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: AppIcon(
                    icon: Icons.arrow_back_ios_new,
                    borderColor: AppColors.primary,
                    borderWidth: 1,
                    size: Dimens.iconS,
                    backgroundColor: AppColors.lightWhite,
                    onTap: onBackPressed ?? () => Navigator.pop(context),
                  ),
                ),
              )
            : null,
        title: heading != null
            ? AppText(heading!, style: theme.textTheme.titleLarge)
            : null,
        centerTitle: true,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      appBar: appBar,
      body: content,
    );
  }
}
