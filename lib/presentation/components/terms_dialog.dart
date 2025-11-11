import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';

class AppTermsDialog extends StatefulWidget {
  final bool initialAgreed;
  final StaticPageModel? termsData;

  const AppTermsDialog({
    super.key,
    required this.initialAgreed,
    this.termsData,
  });

  static Future<bool?> show(
    BuildContext context, {
    required bool agreed,
    required StaticPageModel? termsData,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          AppTermsDialog(initialAgreed: agreed, termsData: termsData),
    );
  }

  @override
  State<AppTermsDialog> createState() => _AppTermsDialogState();
}

class _AppTermsDialogState extends State<AppTermsDialog> {
  late bool _agreedTerms;
  StaticPageModel? pageData;

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
            widget.termsData?.description ?? Common.noDataAvailable,
            overflow: TextOverflow.visible,
          ),
          if (widget.termsData?.description != null)
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
