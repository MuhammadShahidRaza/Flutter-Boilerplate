import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class AppDropdown<T> extends StatelessWidget {
  final String title;
  final String hint;
  final List<T> items;
  final T? value;
  final String Function(T)? getLabel;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.getLabel,
    this.value,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.spacingS,
      children: [
        // Label
        Row(
          children: [
            AppText(
              title,
              fontSize: context.textTheme.bodyMedium?.fontSize,
              fontWeight: FontWeight.w600,
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),

        // Dropdown field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.text,
                ),
              ),
              items: items.map((item) {
                final label = getLabel?.call(item) ?? item.toString();
                return DropdownMenuItem<T>(value: item, child: Text(label));
              }).toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
