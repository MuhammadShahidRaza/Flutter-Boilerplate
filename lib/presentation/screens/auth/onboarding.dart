import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/utils/dimens.dart';
import 'package:sanam_laundry/core/widgets/index.dart'; // AppText, AppButton, etc.
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/common/wrapper.dart';
import 'package:sanam_laundry/presentation/theme/colors.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPage> pages = [
    _OnboardingPage(
      image: AppAssets.logo, // replace with your image
      title: "Welcome to Sanam Laundry",
      description:
          "Fast, reliable, and affordable laundry services at your fingertips.",
    ),
    _OnboardingPage(
      image: AppAssets.logo, // replace with another
      title: "Easy Pickup & Delivery",
      description: "Schedule pickups and deliveries right from the app.",
    ),
    _OnboardingPage(
      image: AppAssets.logo,
      title: "Track Your Orders",
      description: "Stay updated with real-time order tracking.",
    ),
  ];

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
    // TODO: Navigate to Login/Home
    context.replacePage(AppRoutes.login);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      path: page.image,
                      isAsset: true,
                      width: context.screenWidth,
                      height: context.h(0.35),
                    ),
                    const SizedBox(height: Dimens.spacingMLarge),
                    AppText(
                      page.title,
                      style: context.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimens.spacingS),
                    AppText(
                      page.description,
                      style: context.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),

          // Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimens.spacingMLarge),

          // Buttons
          Row(
            children: [
              if (_currentIndex != pages.length - 1)
                Expanded(
                  child: AppButton(title: "Skip", onPressed: _skip),
                ),
              if (_currentIndex != pages.length - 1)
                const SizedBox(width: Dimens.spacingM),

              Expanded(
                child: AppButton(
                  title: _currentIndex == pages.length - 1
                      ? "Get Started"
                      : "Next",
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

class _OnboardingPage {
  final String image;
  final String title;
  final String description;

  _OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}
