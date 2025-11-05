import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: "Booking Details",
      child: Column(
        spacing: Dimens.spacingM,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            path: AppAssets.temp,
            width: context.screenWidth,
            height: context.h(0.3),
            borderRadius: Dimens.radiusM,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Washing:",
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                "Order ID: #123456",
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          AppText("Status:", style: context.textTheme.bodyMedium),

          Stepper(
            currentStep: 2,
            steps: [
              Step(
                title: AppText("Order Placed"),
                content: const SizedBox.shrink(),
                isActive: true,
                state: StepState.complete,
              ),
              Step(
                title: AppText("In Progress"),
                content: const SizedBox.shrink(),
                isActive: true,
                state: StepState.complete,
              ),
              Step(
                title: AppText("Out for Delivery"),
                content: const SizedBox.shrink(),
                isActive: false,
                state: StepState.indexed,
              ),
              Step(
                title: AppText("Delivered"),
                content: const SizedBox.shrink(),
                isActive: false,
                state: StepState.indexed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
