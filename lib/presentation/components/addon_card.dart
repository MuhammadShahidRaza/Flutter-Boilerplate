import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class AddonCard extends StatelessWidget {
  const AddonCard({super.key, required this.service});

  final ServiceItemModel service;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: Dimens.spacingS,
        horizontal: Dimens.spacingS,
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingS),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: Dimens.spacingMSmall,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(
                  path: service.image,
                  width: context.w(0.2),
                  fit: BoxFit.contain,
                  height: context.h(0.06),
                  borderRadius: Dimens.radiusS,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    AppText(
                      service.title,
                      style: context.textTheme.titleMedium!.copyWith(),
                    ),
                    AppText(
                      "${service.amount} SAR",
                      style: context.textTheme.bodySmall!.copyWith(),
                    ),
                  ],
                ),
              ],
            ),

            // Column(
            //   spacing: Dimens.spacingS,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,

            //   children: [
            //     AppIcon(
            //       onTap: () => {},
            //       icon: Icons.add_circle,
            //       color: AppColors.primary,
            //     ),
            //     AppText(
            //       "01",
            //       style: context.textTheme.bodyLarge!.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     AppIcon(
            //       onTap: () => {},
            //       icon: Icons.remove_circle,
            //       color: AppColors.primary,
            //     ),
            //   ],
            // ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIcon(
                      onTap: () => {
                        cart.addService(service),
                        cart.addAddOn(service),
                      },
                      size: 28,
                      icon: Icons.add_circle,
                      color: AppColors.primary,
                    ),
                    AppText(
                      "${cartItem.quantity}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppIcon(
                      onTap: () => {
                        cart.removeService(service),
                        cart.removeAddOn(service),
                      },
                      size: 28,
                      icon: Icons.remove_circle,
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
