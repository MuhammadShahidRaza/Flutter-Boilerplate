import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: true,
      heading: Common.termsAndConditions,
      showBackButton: true,
      child: AppText(
        TemporaryText.lorumIpsumTooLong,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
