import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/static_data.dart';
import 'package:sanam_laundry/presentation/index.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  final AuthRepository _authRepository = AuthRepository();
  StaticPageModel? pageData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    final pageName = context.getParam<String>('name');
    final data = await _authRepository.privacyPolicy(pageName);

    debugPrint('✅ Static page loaded: ${data?.name}');
    if (!mounted) return;

    setState(() {
      pageData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final heading = context.getParam<String>('name') ?? pageData?.name ?? '';

    return AppWrapper(
      scrollable: true,
      heading: heading,
      showBackButton: true,
      child: AppText(
        heading == Common.privacyPolicy
            ? "This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you visit our website or use our services. We are committed to protecting your privacy and ensuring that your personal information is handled with care. This policy explains the types of information we collect, how it is used, and the steps we take to ensure its security. By using our services, you agree to the collection and use of information in accordance with this policy. Please review it carefully."
            : "These Terms & Conditions govern your use of our website and services. By accessing or using our services, you agree to be bound by these terms. You must comply with all applicable laws and regulations when using our site. The content provided is for informational purposes only and may not be used for commercial purposes without prior written consent. We reserve the right to modify these terms at any time, so please review them regularly. Continued use of the site after changes implies acceptance of the updated terms.",
        overflow: TextOverflow.visible,
      ),
      // child: loading
      //     ? const Center(child: CircularProgressIndicator())
      //     : AppText(
      //         pageData?.description ?? Common.noDataAvailable,
      //         overflow: TextOverflow.visible,
      //       ),
    );
  }
}
