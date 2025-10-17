import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color activeColor;
  final Color borderColor;
  final Color checkColor;
  final double size;
  final TextStyle? textStyle;
  final VoidCallback? onTapLabel;
  final Color? splashColor;
  final MainAxisAlignment alignment;

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
    this.onTapLabel,
    this.alignment = MainAxisAlignment.start,
    this.splashColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor,
      highlightColor: splashColor,
      onTap: () => onChanged(!value),
      child: Row(
        spacing: Dimens.spacingS,
        mainAxisAlignment: alignment,
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
              onTap: onTapLabel,
              style: Theme.of(context).textTheme.bodyMedium?.merge(textStyle),
            ),
          ],
        ],
      ),
    );
  }
}
