import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class HorizontalStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: Dimens.spacingS,
        children: List.generate(steps.length, (index) {
          // final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          // final isLast = index == steps.length - 1;

          return Row(
            children: [
              Column(
                spacing: Dimens.spacingXS,
                children: [
                  // Circle indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),

                  // Step label
                  AppText(
                    'Step ${index + 1}',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  AppButton(
                    title: steps[index],
                    onPressed: null,
                    backgroundColor: isCurrent
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),

                    padding: EdgeInsets.symmetric(horizontal: Dimens.spacingS),
                    textStyle: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(context.w(0.25), 30),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.radiusXxs),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
