import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class ServiceItem extends StatefulWidget {
  const ServiceItem({super.key});

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    final CategoryModel category = context.getExtra<CategoryModel>()!;

    return AppWrapper(
      heading: category.title,
      safeArea: false,
      showBackButton: true,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Dimens.spacingM,
        children: [
          Expanded(
            child: Consumer<ServicesProvider>(
              builder: (context, serviceProvider, _) {
                final services = serviceProvider.servicesForCategory(
                  category.id,
                );
                return AppListView<ServiceItemModel>(
                  state: AppListState<ServiceItemModel>(
                    items: services,
                    loadingInitial: serviceProvider.loading,
                    loadingMore: false,
                    hasMore: false,
                  ),
                  onRefresh: () => serviceProvider.fetchServicesByCategoryId(
                    category.id,
                    force: true,
                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, item, index) {
                    final service = services[index];
                    return ServiceCard(service: service, showAddRemove: true);
                  },
                );
              },
            ),
          ),

          if (context.watch<CartProvider>().items.isNotEmpty)
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                final totalAmount = cart.totalAmount;
                const freeDeliveryThreshold = 1000.0;
                final remaining = (freeDeliveryThreshold - totalAmount).clamp(
                  0,
                  freeDeliveryThreshold,
                );
                final isFreeDelivery = totalAmount >= freeDeliveryThreshold;

                return Column(
                  spacing: Dimens.spacingM,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: SliderComponentShape.noThumb,
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: totalAmount.clamp(0, freeDeliveryThreshold),
                        max: freeDeliveryThreshold,
                        min: 0,
                        onChanged: (_) {},
                        activeColor: AppColors.secondary,
                        inactiveColor: AppColors.border,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.screenMarginHorizontal,
                      ),
                      child: Row(
                        spacing: Dimens.spacingM,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              isFreeDelivery
                                  ? "You qualify for free delivery 🎉"
                                  : "${remaining.toStringAsFixed(2)} SAR remaining to qualify for free delivery",
                              maxLines: 2,
                            ),
                          ),
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
                );
              },
            ),
        ],
      ),
    );
  }
}
