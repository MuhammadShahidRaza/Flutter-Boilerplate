import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'Wash & Fold', 'subtitle': '2 items · Delivered'},
      {'title': 'Dry Cleaning', 'subtitle': '5 items · In Progress'},
      {'title': 'Ironing Service', 'subtitle': '3 items · Ready for Pickup'},
    ];

    return AppWrapper(
      appBar: HomeAppBar(userName: "Aldo Bareto"),
      child: Column(
        children: [
          AppImage(
            path: AppAssets.temp,
            height: 200,
            width: context.screenWidth,
            fit: BoxFit.contain,
          ),
          AppText(Common.categories),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.local_laundry_service,
                      color: AppColors.primary,
                    ),
                  ),
                  title: AppText(
                    item['title'] ?? '',
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: AppText(
                    item['subtitle'] ?? '',
                    color: AppColors.textSecondary,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // handle navigation
                    context.navigate(AppRoutes.services);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
