import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: true,
      heading: Common.privacyPolicy,
      showBackButton: true,
      child: AppText(
        TemporaryText.lorumIpsumTooLong,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
