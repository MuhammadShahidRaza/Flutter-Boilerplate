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

  Widget _buildBottomRow() {
    final isLastPage = _currentIndex == pages.length - 1;

    return SizedBox(
      height: Dimens.buttonHeight,
      child: isLastPage
          ? Center(
              child: AppButton(
                title: Common.getStarted,
                onPressed: _nextPage,
                width: context.w(0.65),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  Common.skip,
                  style: context.textTheme.titleLarge,
                  onTap: _skip,
                ),
                AppIcon(
                  icon: Icons.arrow_forward,
                  onTap: _nextPage,
                  color: AppColors.white,
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(10),
                  borderRadius: 30,
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: false,
      child: Stack(
        children: [
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
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
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
                        width: _currentIndex == index
                            ? Dimens.iconL
                            : Dimens.iconS,
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

              _buildBottomRow(),
            ],
          ),
        ],
      ),
    );
  }
}
