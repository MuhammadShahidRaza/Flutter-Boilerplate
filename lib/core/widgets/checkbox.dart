import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color activeColor;
  final Color borderColor;
  final Color checkColor;
  final double size;
  final TextStyle? textStyle;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor = AppColors.secondary,
    this.borderColor = AppColors.secondary,
    this.checkColor = AppColors.white,
    this.size = Dimens.iconM,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        spacing: Dimens.spacingS,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: value ? activeColor : Colors.transparent,
              border: Border.all(
                color: value ? activeColor : borderColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(Dimens.radiusXxs),
            ),
            child: value
                ? AppIcon(
                    icon: Icons.check,
                    size: size * 0.7,
                    color: checkColor,
                  )
                : null,
          ),
          if (label != null) ...[
            AppText(
              label!,
              style: Theme.of(context).textTheme.bodyMedium?.merge(textStyle),
            ),
          ],
        ],
      ),
    );
  }
}
