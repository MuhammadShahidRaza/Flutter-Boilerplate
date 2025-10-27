import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return AppWrapper(
      heading: Common.changeLanguage,
      showBackButton: true,
      child: Stack(
        children: [
          // 🔹 Background watermark
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.07,
                child: AppImage(
                  path: AppAssets.watermark,
                  width: context.screenWidth,
                  height: context.h(0.45),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🔹 Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: Dimens.spacingLarge,
            children: [
              // Small description at the top
              AppText(
                Common.selectLanguageYouAreComfortableWith,
                style: context.textTheme.bodyMedium,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),

              // Language options
              Column(
                spacing: Dimens.spacingLarge,
                children: [
                  _LanguageTile(
                    title: 'English',
                    selected: provider.locale.languageCode == 'en',
                    onTap: () => provider.changeLanguage(Language.en),
                  ),
                  _LanguageTile(
                    title: 'Arabic (العربية)',
                    selected: provider.locale.languageCode == 'ar',
                    onTap: () => provider.changeLanguage(Language.ar),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      title: AppText(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? AppColors.primary : AppColors.bottomTabText,
        ),
      ),

      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
      onTap: onTap,
    );
  }
}
