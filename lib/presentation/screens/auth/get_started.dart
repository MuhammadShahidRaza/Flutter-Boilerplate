import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/common/wrapper.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleImageTap(BuildContext context) {
    final now = DateTime.now();

    // Reset counter if taps are more than 1.5 seconds apart
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 0;
    }

    _lastTapTime = now;
    _tapCount++;

    if (_tapCount == 5) {
      _tapCount = 0;
      context.navigate(AppRoutes.login);
    }
  }

  void _submit() {
    context.replacePage(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      safeArea: false,
      padding: EdgeInsets.zero,
      child: Column(
        spacing: Dimens.spacingLarge,
        children: [
          AppImage(
            onTap: () => _handleImageTap(context),
            path: AppAssets.getStarted,
            isAsset: true,
            width: context.screenWidth,
            height: context.h(0.63),
            fit: BoxFit.cover,
          ),
          AppText(
            Auth.welcomeBackGetStarted,
            style: context.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 20),
            child: AppText(
              Auth.getStartedDescription,
              style: context.textTheme.titleSmall,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
              maxLines: 5,
            ),
          ),
          Center(
            child: AppButton(title: Common.signInWithPhone, onPressed: _submit),
          ),
        ],
      ),
    );
  }
}
