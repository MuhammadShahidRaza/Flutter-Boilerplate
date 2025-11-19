import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AddonCard extends StatelessWidget {
  const AddonCard({super.key, required this.service});

  final Map<String, dynamic> service;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: Dimens.spacingS,
        horizontal: Dimens.spacingS,
      ),
      child: InkWell(
        onTap: () {
          // Navigate to service detail or add to cart
        },
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Dimens.spacingMSmall,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppImage(
                    path: service["image"],
                    width: context.w(0.2),
                    height: context.h(0.07),
                    borderRadius: Dimens.radiusS,
                  ),
                  AppText(
                    service["name"],
                    style: context.textTheme.titleMedium!.copyWith(),
                  ),
                ],
              ),

              Column(
                spacing: Dimens.spacingS,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  AppIcon(
                    onTap: () => {},
                    icon: Icons.add_circle,
                    color: AppColors.primary,
                  ),
                  AppText(
                    "01",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppIcon(
                    onTap: () => {},
                    icon: Icons.remove_circle,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
