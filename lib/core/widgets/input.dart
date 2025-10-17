import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

enum FieldType { email, password, confirmPassword, name, phone, required }

class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? title;
  final FieldType? fieldKey;
  final TextEditingController controller;
  final TextEditingController?
  originalPasswordController; // 👈 for confirm password
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final double marginBottom;
  final int? minLength;
  final int? maxLength;
  final bool isRequired;

  const AppInput({
    super.key,
    this.label,
    this.title,
    this.hint,
    this.fieldKey,
    required this.controller,
    this.originalPasswordController,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.isRequired = false,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.marginBottom = Dimens.spacingS,
    this.minLength,
    this.maxLength,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;

    // 👇 Watch original password field for confirm-password live validation
    if (widget.fieldKey == FieldType.confirmPassword &&
        widget.originalPasswordController != null) {
      widget.originalPasswordController!.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  String? _validator(BuildContext context, String? value) {
    String? error;

    switch (widget.fieldKey) {
      case FieldType.email:
        error = AppValidators.email(context, value);
        break;

      case FieldType.password:
        error = AppValidators.password(context, value);
        break;

      case FieldType.confirmPassword:
        error = AppValidators.confirmPassword(
          context,
          value,
          widget.originalPasswordController?.text,
        );
        break;

      case FieldType.name:
        error = AppValidators.name(
          context,
          value,
          fieldName: widget.label ?? Common.name,
        );
        break;

      case FieldType.phone:
        error = AppValidators.phone(context, value);
        break;

      case FieldType.required:
        error = AppValidators.requiredField(
          context,
          value,
          fieldName: widget.label ?? Common.feild,
        );
        break;

      default:
        error = null;
    }

    // Extra: min/max length checks
    if (error == null && widget.minLength != null) {
      error = AppValidators.minLength(context, value, min: widget.minLength!);
    }

    if (error == null && widget.maxLength != null) {
      error = AppValidators.maxLength(context, value, max: widget.maxLength!);
    }

    return error;
  }

  TextInputType _keyboardType() {
    switch (widget.fieldKey) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom),
      child: Column(
        spacing: Dimens.spacingS,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Row(
              children: [
                AppText(widget.title!, style: context.textTheme.titleSmall),
                if (widget.isRequired)
                  const AppText(' *', color: AppColors.red),
              ],
            ),
          ],
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType ?? _keyboardType(),
            obscureText: _obscure,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            enabled: widget.enabled,
            validator: (value) => _validator(context, value),
            textCapitalization: widget.textCapitalization,
            style: context.textTheme.bodyMedium,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              errorMaxLines: 3,
              labelText: widget.label != null
                  ? context.tr(widget.label!)
                  : null,
              hintText: widget.hint != null ? context.tr(widget.hint!) : null,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
