import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  // final Future<bool> Function()? onWillPop;
  final bool safeArea;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? heading;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool useScaffold;
  final PreferredSizeWidget? appBar;

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
    this.bottomNavigationBar,
    this.useScaffold = true,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBackground = backgroundColor ?? theme.scaffoldBackgroundColor;

    // // 🔙 Handle hardware back press
    // content = WillPopScope(
    //   onWillPop:
    //       onWillPop ??
    //       () async {
    //         return true;
    //       },
    //   child: content,
    // );

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

    // ✅ Use the property directly (don’t redeclare `appBar`)
    final PreferredSizeWidget? resolvedAppBar =
        appBar ??
        ((showBackButton || heading != null)
            ? AppBarComponent(
                heading: heading,
                showBackButton: showBackButton,
                onBackPressed: onBackPressed,
                backgroundColor: backgroundColor,
              )
            : null);

    if (!useScaffold) {
      return ColoredBox(color: resolvedBackground, child: content);
    }

    return Scaffold(
      backgroundColor: resolvedBackground,
      appBar: resolvedAppBar,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
