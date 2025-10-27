import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'Washing',
        'subtitle':
            'Your clothes are freshly washed and neatly folded.\nDelivered right to your doorstep.',
      },
      {
        'title': 'Dry Cleaning',
        'subtitle':
            'Premium dry cleaning in progress with gentle care.\nWe’ll notify you once it’s ready for pickup.',
      },
      {
        'title': 'Ironing',
        'subtitle':
            'Your garments are being perfectly pressed.\nThey’ll be ready for pickup soon.',
      },
    ];

    return AppWrapper(
      appBar: HomeAppBar(),
      child: Column(
        children: [
          AppImage(
            path: AppAssets.temp,
            height: context.h(0.3),
            width: context.screenWidth,
            fit: BoxFit.contain,
          ),

          AppText(Common.categories, fontSize: 20, fontWeight: FontWeight.bold),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: Dimens.spacingXS,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 Left image/icon
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          Icons.local_laundry_service,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 🔹 Title + subtitle text
                      Expanded(
                        child: Column(
                          spacing: Dimens.spacingXS,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              item['title'] ?? '',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            AppText(
                              item['subtitle'] ?? '',
                              color: AppColors.textSecondary,
                              maxLines: 2,
                              fontSize: 11,
                            ),
                          ],
                        ),
                      ),

                      // 🔹 Right button
                      AppButton(
                        title: "View Services",
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(20, 30)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 12,
                        ),
                        textStyle: context.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          context.navigate(AppRoutes.services);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
