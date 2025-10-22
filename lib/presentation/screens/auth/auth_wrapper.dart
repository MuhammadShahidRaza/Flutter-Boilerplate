import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/common/wrapper.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class AuthWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String buttonText;
  final VoidCallback onSubmit;
  final VoidCallback? bottomButtonPress;
  final String bottomButtonText;
  final String bottomText;
  final GlobalKey<FormState> formKey;
  final bool showWatermark;
  final bool height;
  final bool isButtonEnabled;
  final bool showBackButton;
  final String? heading;
  final bool isLoading;

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
    this.bottomButtonText = "",
    this.bottomText = "",
    this.isButtonEnabled = true,
    this.bottomButtonPress,
    this.heading,
    this.showBackButton = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      heading: heading,
      showBackButton: false,
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
                spacing: Dimens.spacingM,
                children: [
                  Stack(
                    children: [
                      AppImage(
                        path: AppAssets.logo,
                        width: context.screenWidth,
                        height: context.h(0.31),
                      ),
                      if (showBackButton)
                        Positioned(
                          top: 10,
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: AppIcon(
                              icon: Icons.arrow_back_ios_new,
                              borderColor: AppColors.primary,
                              borderWidth: 1,
                              size: Dimens.iconS,
                              backgroundColor: AppColors.lightWhite,
                              onTap: () => context.pop(context),
                            ),
                          ),
                        ),
                    ],
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
                  AppButton(
                    title: buttonText,
                    onPressed: () {
                      if (!(formKey.isValid)) return;
                      onSubmit();
                    },
                    isLoading: isLoading,
                    isEnabled: isButtonEnabled,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        bottomText,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppButton(
                        type: AppButtonType.text,
                        width: context.w(0.1),
                        title: bottomButtonText,
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: Dimens.spacingXS),
                          ),
                          minimumSize: WidgetStatePropertyAll(Size(0, 0)),
                        ),
                        textStyle: context.textTheme.titleSmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: bottomButtonPress,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
