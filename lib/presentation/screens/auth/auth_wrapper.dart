import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/common/wrapper.dart';

class AuthWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String buttonText;
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;
  final bool showWatermark;
  final bool height;

  const AuthWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.buttonText,
    required this.onSubmit,
    required this.formKey,
    this.height = false,
    this.showWatermark = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: true,
      child: SizedBox(
        height: height ? context.h(0.88) : null,
        child: Stack(
          children: [
            if (showWatermark)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.07,
                    child: AppImage(
                      path: AppAssets.watermark,
                      isAsset: true,
                      width: context.screenWidth,
                      height: context.h(0.45),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

            Form(
              key: formKey,
              child: Column(
                spacing: Dimens.spacingMLarge,
                children: [
                  AppImage(
                    path: AppAssets.logo,
                    isAsset: true,
                    width: context.screenWidth,
                    height: context.h(0.31),
                  ),
                  AppText(
                    title,
                    fontSize: context.textTheme.headlineMedium?.fontSize,
                    fontWeight: context.textTheme.headlineMedium?.fontWeight,
                  ),
                  AppText(
                    subtitle,
                    fontSize: context.textTheme.bodyMedium?.fontSize,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                  child,
                  AppButton(title: buttonText, onPressed: onSubmit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
