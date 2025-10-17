import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/data/models/index.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final List<AppBottomSheetOption> options;
  final bool showCancelButton;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.options,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          if (title != null) ListTile(title: AppText(title!)),
          ...options.map(
            (option) => ListTile(
              leading: AppIcon(icon: option.icon),
              title: AppText(option.title),
              onTap: option.onTap,
            ),
          ),
          if (showCancelButton)
            ListTile(
              leading: AppIcon(icon: Icons.close),
              title: const AppText(Common.cancel),
              onTap: () => context.pop(),
            ),
        ],
      ),
    );
  }
}
