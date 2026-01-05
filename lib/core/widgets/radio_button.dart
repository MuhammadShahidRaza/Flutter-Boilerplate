import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppRadioItem<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final String? description;
  final ValueChanged<T> onChanged;
  final TextStyle? labelStyle;
  final TextStyle? descriptionStyle;
  final Widget? iconWidget;

  const AppRadioItem({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    this.labelStyle,
    this.description,
    this.iconWidget,
    this.descriptionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      onTap: () => onChanged(value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingMSmall,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Radio<T>(
              value: value,
              groupValue: groupValue,
              side: BorderSide(color: AppColors.primary, width: 3),
              activeColor: AppColors.primary,
              onChanged: (val) => onChanged(val as T),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.spacingXS,
              children: [
                AppText(label, style: labelStyle),
                if (description != null)
                  AppText(description!, style: descriptionStyle, maxLines: 3),
              ],
            ),
          ),

          if (iconWidget != null) iconWidget!,
        ],
      ),
    );
  }
}
