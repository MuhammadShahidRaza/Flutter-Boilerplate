import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MessageBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final int? descriptionMaxLines;

  const MessageBox({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.descriptionMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.spacingMSmall,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(icon: icon, color: AppColors.primary),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.spacingXS,
            children: [
              AppText(
                title,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                value,
                maxLines: descriptionMaxLines,
                style: context.textTheme.bodySmall!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
