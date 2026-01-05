import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  late String _selectedLangCode;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _selectedLangCode = provider.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isFromSplash = context.getParam<bool>('isFromSplash') ?? false;

    return AppWrapper(
      heading: isFromSplash ? Common.chooseLanguage : Common.changeLanguage,
      showBackButton: isFromSplash ? false : true,
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

          // 🔹 Content
          Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: Dimens.spacingLarge,
                  children: [
                    AppText(
                      Common.selectLanguageYouAreComfortableWith,
                      style: context.textTheme.bodyMedium,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                    _LanguageTile(
                      title: 'English',
                      selected: _selectedLangCode == 'en',
                      onTap: () => setState(() => _selectedLangCode = 'en'),
                    ),
                    _LanguageTile(
                      title: 'Arabic (العربية)',
                      selected: _selectedLangCode == 'ar',
                      onTap: () => setState(() => _selectedLangCode = 'ar'),
                    ),
                  ],
                ),
              ),

              // 🔹 Save button
              AppButton(
                title: Common.save,
                onPressed: () {
                  // apply the selected language
                  if (_selectedLangCode == 'ar') {
                    provider.changeLanguage(Language.ar);
                  } else {
                    provider.changeLanguage(Language.en);
                  }

                  if (isFromSplash) {
                    context.replacePage(AppRoutes.onboarding);
                    return;
                  }
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!context.mounted) return;
                    if (context.read<UserProvider>().isRider == false) {
                      context.read<ServicesProvider>().fetchCategories(
                        forceRefresh: true,
                      );
                    }
                    context.back();
                  });
                },
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
      onTap: onTap,
    );
  }
}
