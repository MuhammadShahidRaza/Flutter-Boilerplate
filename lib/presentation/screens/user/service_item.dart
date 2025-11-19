import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class ServiceItem extends StatefulWidget {
  const ServiceItem({super.key});

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  List<Map<String, dynamic>> serviceItems = [];

  // String? selectedCategoryId;
  bool loadingServiceItems = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadServices(selectedCategoryId!);
  // }

  @override
  void initState() {
    super.initState();
    _loadServices(""); // pass an empty string to avoid null
  }

  Future<void> _loadServices(String categoryId) async {
    setState(() {
      loadingServiceItems = true;
    });

    // 🔹 Simulating service Iteem API per service
    await Future.delayed(const Duration(milliseconds: 800));
    final data = [
      {"id": "11", "name": "Washing", "image": AppAssets.getStarted},
      {"id": "12", "name": "Ironing", "image": AppAssets.onboardingOne},
      {"id": "13", "name": "Dry Cleaning", "image": AppAssets.onboardingThree},
      {"id": "14", "name": "Stitching", "image": AppAssets.user},
    ];

    setState(() {
      serviceItems = data;
      loadingServiceItems = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> service = context
        .getExtra<Map<String, dynamic>>()?["item"];

    return AppWrapper(
      heading: service['title'],
      safeArea: false,
      showBackButton: true,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Dimens.spacingM,
        children: [
          Expanded(
            child: loadingServiceItems
                ? const Center(child: CircularProgressIndicator())
                : serviceItems.isEmpty
                ? const Center(child: AppText("No services available"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: serviceItems.length,
                    itemBuilder: (context, index) {
                      final service = serviceItems[index];
                      return ServiceCard(service: service, showAddRemove: true);
                    },
                  ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: SliderComponentShape.noThumb, // ✅ Hides the thumb
              overlayShape:
                  SliderComponentShape.noOverlay, // optional: removes ripple
            ),
            child: Slider(
              value: 2,
              max: 10,
              min: 0,
              onChanged: (value) {},
              activeColor: AppColors.secondary,
              inactiveColor: AppColors.border,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenMarginHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText("15 SAR remaining to qualify for free delivery"),
                AppIcon(
                  icon: Icons.local_shipping_outlined,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          AppButton(
            title: "Place Order",
            onPressed: () {
              context.navigate(AppRoutes.orderDetails);
            },
          ),
        ],
      ),
    );
  }
}
