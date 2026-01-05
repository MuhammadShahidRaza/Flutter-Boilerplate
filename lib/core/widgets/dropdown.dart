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
  final double marginBottom;
  final bool showBorder;
  final TextStyle? itemTextStyle;

  const AppDropdown({
    super.key,
    this.title = '',
    this.hint = '',
    required this.items,
    required this.onChanged,
    this.getLabel,
    this.value,
    this.marginBottom = Dimens.spacingS,
    this.isRequired = false,
    this.enabled = true,
    this.showBorder = true,
    this.itemTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingS,
        children: [
          // Label
          if (title.isNotEmpty)
            Row(
              children: [
                AppText(title, style: context.textTheme.titleSmall),
                if (isRequired) const AppText(' *', color: AppColors.red),
              ],
            ),
          FormField<T>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (isRequired) {
                return AppValidators.requiredField(
                  context,
                  val as String?,
                  fieldName: title,
                );
              }
              return null;
            },
            builder: (FormFieldState<T> field) {
              return InputDecorator(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  enabledBorder: showBorder ? null : InputBorder.none,
                  errorText: field.errorText,
                  errorMaxLines: 3,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    isExpanded: true,
                    value: value,
                    hint: AppText(
                      hint,
                      style: theme.inputDecorationTheme.hintStyle,
                    ),
                    items: items.map((item) {
                      final label = getLabel?.call(item) ?? item.toString();
                      return DropdownMenuItem<T>(
                        value: item,
                        child: AppText(label, style: itemTextStyle),
                      );
                    }).toList(),
                    onChanged: enabled
                        ? (newVal) {
                            field.didChange(newVal);
                            onChanged(newVal);
                          }
                        : null,
                    borderRadius: BorderRadius.circular(Dimens.buttonRadius),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
