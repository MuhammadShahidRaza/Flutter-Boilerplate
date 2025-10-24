import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class AppPhoneInput extends StatefulWidget {
  final String title;
  final String? label;
  final String hint;
  final bool isRequired;
  final TextEditingController controller;
  final ValueChanged<PhoneNumber>? onChanged;
  final double marginBottom;
  final bool enabled;
  final String searchCountryPlaceholder;

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
    this.searchCountryPlaceholder = Common.searchByCountryNameOrDialCode,
  });

  @override
  State<AppPhoneInput> createState() => _AppPhoneInputState();
}

class _AppPhoneInputState extends State<AppPhoneInput> {
  static const String defaultIsoCode = 'SA';
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  PhoneNumber _number = PhoneNumber(isoCode: defaultIsoCode);
  bool _isValid = false;
  @override
  void initState() {
    super.initState();
    _initializePhoneNumber();
  }

  Future<void> _initializePhoneNumber() async {
    if (widget.controller.text.isNotEmpty) {
      try {
        final number = await PhoneNumber.getRegionInfoFromPhoneNumber(
          widget.controller.text,
        );
        if (!mounted) return;
        setState(() => _number = number);
      } catch (_) {
        // fallback if parsing fails
        if (!mounted) return;
        setState(() {
          _number = PhoneNumber(
            phoneNumber: widget.controller.text,
            isoCode: defaultIsoCode,
          );
        });
      }
    } else {
      _number = PhoneNumber(isoCode: defaultIsoCode);
    }
  }

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
          InternationalPhoneNumberInput(
            key: _fieldKey,
            initialValue: _number,
            isEnabled: widget.enabled,
            onInputChanged: (PhoneNumber number) {
              setState(() => _number = number);
              widget.controller.text = number.phoneNumber ?? '';
              widget.onChanged?.call(number);
            },
            locale: context.watch<AuthProvider>().locale.languageCode,
            onInputValidated: (bool valid) {
              if (mounted) {
                setState(() => _isValid = valid);
                _fieldKey.currentState?.validate();
              }
            },
            searchBoxDecoration: InputDecoration(
              hintText: context.tr(widget.searchCountryPlaceholder),
            ),
            inputDecoration: InputDecoration(
              errorMaxLines: 3,
              hintText: context.tr(widget.hint),
            ),
            validator: (value) => _validator(context, value),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              useBottomSheetSafeArea: true,
              setSelectorButtonAsPrefixIcon: true,
              leadingPadding: 20,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: context.textTheme.bodyMedium,
            formatInput: false,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
