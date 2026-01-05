import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  final AuthRepository _authRepository = AuthRepository();
  StaticPageModel? pageData;
  bool loading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadPage();
    }
  }

  Future<void> _loadPage() async {
    final pageName = context.getParam<String>('name');
    final data = await _authRepository.privacyPolicy(pageName);

    if (!mounted) return;
    setState(() {
      pageData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final heading = context.getParam<String>('name') ?? pageData?.name ?? '';
    final html = pageData?.description ?? '';

    return AppWrapper(
      scrollable: true,
      heading: heading,
      showBackButton: true,
      child: loading
          ? const DetailPageSkeleton()
          : HtmlWidget(
              html,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              onTapUrl: (url) async {
                final uri = Uri.tryParse(url);
                if (uri == null) return false;
                return launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
    );
  }
}
