import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/category.dart';
import 'package:sanam_laundry/presentation/index.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isSelected;
  final CategoryModel data;
  const CategoryCard({
    super.key,
    this.onTap,
    required this.data,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isSelected ? 0.1 : 0),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.transparent,
              width: isSelected ? 3 : 0,
            ),
            borderRadius: BorderRadius.circular(Dimens.radiusMSmall),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            spacing: Dimens.spacingMSmall,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Left image/icon
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: const Radius.circular(Dimens.radiusXL),
                  color: isSelected ? AppColors.white : AppColors.primary,
                  padding: EdgeInsets.all(Dimens.spacingXS),
                ),
                child: Container(
                  width: 55,
                  height: 55,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.radiusXL),
                    color: isSelected
                        ? AppColors.white
                        : AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: AppImage(
                    path: data.image,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    borderRadius: Dimens.radiusXL,
                  ),
                ),
              ),

              // 🔹 Title + subtitle text
              Expanded(
                child: Column(
                  spacing: Dimens.spacingXS,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data.title,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    AppText(
                      data.subtitle,
                      color: AppColors.textSecondary,
                      maxLines: 2,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),

              // 🔹 Right button
              AppButton(
                title: "View Services",
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(20, 30)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radiusXs),
                    ),
                  ),
                ),
                type: isSelected
                    ? AppButtonType.elevated
                    : AppButtonType.outlined,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                textStyle: context.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.white : AppColors.text,
                ),
                onPressed: () {
                  context.navigate(
                    AppRoutes.serviceItem,
                    extra: {'item': data},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
