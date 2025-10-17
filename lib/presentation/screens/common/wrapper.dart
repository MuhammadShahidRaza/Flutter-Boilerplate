import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/dimens.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  const AppWrapper({
    super.key,
    required this.child,
    this.scrollable = false,
    this.padding,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(body: content);
  }
}
