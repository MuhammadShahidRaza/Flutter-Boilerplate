import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';

class AppTermsDialog extends StatefulWidget {
  final bool initialAgreed;

  const AppTermsDialog({super.key, required this.initialAgreed});

  static Future<bool?> show(BuildContext context, {required bool agreed}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AppTermsDialog(initialAgreed: agreed),
    );
  }

  @override
  State<AppTermsDialog> createState() => _AppTermsDialogState();
}

class _AppTermsDialogState extends State<AppTermsDialog> {
  late bool _agreedTerms;

  @override
  void initState() {
    super.initState();
    _agreedTerms = widget.initialAgreed;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Common.termOfUseAndPrivacy,
      content: Column(
        spacing: Dimens.spacingM,
        children: [
          AppText(
            TemporaryText.lorumIpsumTooLong,
            overflow: TextOverflow.visible,
          ),
          AppCheckbox(
            value: _agreedTerms,
            onChanged: (bool val) => setState(() => _agreedTerms = val),
            label: Common.termOfUseAndPrivacy,
            alignment: MainAxisAlignment.center,
          ),
        ],
      ),
      primaryButtonText: Common.continue_,
      onPrimaryPressed: () => Navigator.pop(context, _agreedTerms),
      isEnabledButton: _agreedTerms,
    );
  }
}
