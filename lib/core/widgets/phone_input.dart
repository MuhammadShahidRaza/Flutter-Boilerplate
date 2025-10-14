import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class AppPhoneInput extends StatefulWidget {
  final String title;
  final String? label;
  final String hint;
  final bool isRequired;
  final TextEditingController controller;
  final ValueChanged<PhoneNumber>? onChanged;
  final double marginBottom;
  final bool enabled;

  const AppPhoneInput({
    super.key,
    required this.title,
    required this.controller,
    required this.hint,
    this.label,
    this.isRequired = false,
    this.onChanged,
    this.marginBottom = Dimens.spacingS,
    this.enabled = true,
  });

  @override
  State<AppPhoneInput> createState() => _AppPhoneInputState();
}

class _AppPhoneInputState extends State<AppPhoneInput> {
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  PhoneNumber _number = PhoneNumber(isoCode: 'AE');
  bool _isValid = false;

  String? _validator(BuildContext context, String? value) {
    // first run your existing validator (required/format checks you already have)
    final baseError = AppValidators.phone(context, value);
    if (baseError != null) return baseError;

    // If field is non-empty and package says it's invalid -> show error
    if (value != null && value.trim().isNotEmpty && !_isValid) {
      return context.tr(ValidationMessages.invalidPhoneNumber);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom),
      child: Column(
        spacing: Dimens.spacingS,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              AppText(widget.title, style: context.textTheme.titleSmall),
              if (widget.isRequired) const AppText(' *', color: AppColors.red),
            ],
          ),

          // Phone Input
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: AppColors.border),
          //     borderRadius: BorderRadius.circular(Dimens.inputRadius),
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          //   child:
          InternationalPhoneNumberInput(
            key: _fieldKey,
            textFieldController: widget.controller,
            initialValue: _number,
            hintText: context.tr(widget.hint),
            onInputChanged: (PhoneNumber number) {
              setState(() => _number = number);
              widget.onChanged?.call(number);
            },
            onInputValidated: (bool valid) {
              if (mounted) {
                setState(() => _isValid = valid);
                // trigger the FormField validator to run and show error if any
                _fieldKey.currentState?.validate();
              }
            },
            inputDecoration: InputDecoration(errorMaxLines: 3),
            validator: (value) => _validator(context, value),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              useBottomSheetSafeArea: true,
              setSelectorButtonAsPrefixIcon: true,
              leadingPadding: 20,
              useEmoji: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: context.textTheme.bodyMedium,
            inputBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            formatInput: false,
            keyboardType: TextInputType.phone,
          ),
          // ),
        ],
      ),
    );
  }
}
