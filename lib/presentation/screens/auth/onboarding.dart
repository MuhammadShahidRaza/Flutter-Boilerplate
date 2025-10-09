import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/routes/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/data/models/onboarding.dart';
import 'package:sanam_laundry/presentation/screens/common/wrapper.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      image: AppAssets.onboardingOne,
      title: OnboardingText.heading1,
      description: OnboardingText.description1,
    ),
    OnboardingModel(
      image: AppAssets.onboardingTwo,
      title: OnboardingText.heading2,
      description: OnboardingText.description2,
    ),
    OnboardingModel(
      image: AppAssets.onboardingThree,
      title: OnboardingText.heading3,
      description: OnboardingText.description3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _autoSlideTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  void _finish() {
    context.replacePage(AppRoutes.login);
  }

  void _moveToCurrentPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: false,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final page = pages[index];
                return Column(
                  children: [
                    AppImage(
                      path: page.image,
                      isAsset: true,
                      fit: BoxFit.contain,
                      width: context.screenWidth,
                      height: context.h(0.35),
                    ),
                    const SizedBox(height: Dimens.spacingXL),
                    AppText(
                      page.title,
                      style: context.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimens.spacingM),
                    AppText(
                      page.description,
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                      maxLines: 5,
                    ),
                  ],
                );
              },
            ),
          ),

          // Indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => InkWell(
                  onTap: () => _moveToCurrentPage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: Dimens.iconS,
                    width: _currentIndex == index ? Dimens.iconL : Dimens.iconS,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.secondary,
                      borderRadius: BorderRadius.circular(Dimens.iconS),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Buttons
          Row(
            children: [
              if (_currentIndex != pages.length - 1) ...[
                // AppIcon(icon: icon)
                Expanded(
                  child: AppButton(title: Common.skip, onPressed: _skip),
                ),
                const SizedBox(width: Dimens.spacingM),
              ] else
                Expanded(
                  child: AppButton(
                    title: _currentIndex == pages.length - 1
                        ? Common.getStarted
                        : Common.next,
                    onPressed: _nextPage,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
