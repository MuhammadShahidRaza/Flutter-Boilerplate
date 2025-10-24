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
            "This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you visit our website or use our services. We are committed to protecting your privacy and ensuring that your personal information is handled with care. This policy explains the types of information we collect, how it is used, and the steps we take to ensure its security. By using our services, you agree to the collection and use of information in accordance with this policy. Please review it carefully.",
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
