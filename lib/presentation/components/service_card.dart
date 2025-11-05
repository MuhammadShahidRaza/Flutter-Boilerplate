import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.isFromHome,
  });

  final Map<String, dynamic> service;
  final bool isFromHome;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
      child: InkWell(
        onTap: () {
          // Navigate to service detail or add to cart
        },
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingS),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.spacingMSmall,
            children: [
              AppImage(
                path: service["image"],
                width: context.w(0.30),
                height: context.h(0.12),
                borderRadius: Dimens.radiusS,
              ),
              Expanded(
                child: Column(
                  spacing: Dimens.spacingXS,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      service["name"],
                      style: context.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: context.w(0.45),
                      child: AppText(
                        TemporaryText.lorumIpsum,
                        maxLines: 2,

                        style: context.textTheme.bodySmall!.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    AppText(
                      "150 SAR",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (isFromHome)
                Column(
                  spacing: Dimens.spacingS,
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
