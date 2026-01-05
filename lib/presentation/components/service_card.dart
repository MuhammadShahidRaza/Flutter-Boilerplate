import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.showAddRemove,
  });

  final ServiceItemModel service;
  final bool showAddRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingS),
        child: Row(
          spacing: Dimens.spacingMSmall,
          children: [
            AppImage(
              path: service.image,
              width: context.w(0.30),
              height: context.h(0.12),
              borderRadius: Dimens.radiusS,
            ),
            Expanded(
              child: Column(
                spacing: Dimens.spacingXS,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    service.title,
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(
                    width: context.w(0.45),
                    child: AppText(
                      service.description,
                      maxLines: 3,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  AppText(
                    "${service.amount} ${service.currency}",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            if (showAddRemove)
              Consumer<CartProvider>(
                builder: (context, cart, _) {
                  // Get the quantity of this service in cart
                  final cartItem = cart.items.firstWhere(
                    (e) => e.serviceId == int.parse(service.id),
                    orElse: () => CartItem(
                      serviceId: int.parse(service.id),
                      serviceName: service.title,
                      quantity: 0,
                      amount: double.parse(service.amount),
                    ),
                  );

                  return Column(
                    spacing: Dimens.spacingS,
                    children: [
                      AppIcon(
                        onTap: () => cart.addService(service),
                        icon: Icons.add_circle,
                        padding: EdgeInsets.symmetric(vertical: 2),
                        color: AppColors.primary,
                      ),
                      AppText(
                        "${cartItem.quantity}",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppIcon(
                        onTap: () => cart.removeService(service),
                        icon: Icons.remove_circle,
                        padding: EdgeInsets.symmetric(vertical: 2),
                        color: AppColors.primary,
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
