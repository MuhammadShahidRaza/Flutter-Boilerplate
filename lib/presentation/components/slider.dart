import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class SliderList extends StatefulWidget {
  final List<String> list;
  const SliderList({super.key, required this.list});

  @override
  State<SliderList> createState() => _SliderListState();
}

class _SliderListState extends State<SliderList> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < widget.list.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(0.27),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.list.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final page = widget.list[index];
              return AppImage(
                path: page,
                borderRadius: Dimens.radiusM,
                width: context.screenWidth,
                fit: BoxFit.cover,
              );
            },
          ),

          // 🔹 Dot Indicators
          Positioned(
            bottom: 12,
            left: context.w(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.list.length, (index) {
                final isActive = _currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: isActive ? 6 : 5,
                  width: isActive ? 20 : 15,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightBlackOpacity,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
