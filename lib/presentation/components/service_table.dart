import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/presentation/index.dart';

class ServicesTable extends StatelessWidget {
  final List<CartItem> services;
  const ServicesTable({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Dimens.spacingS),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  "Services",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AppText(
                  "QTY",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AppText(
                  "Charges",
                  textAlign: TextAlign.right,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Rows
        ...services.map((service) {
          return _ServiceRow(
            name: service.serviceName,
            qty: service.quantity.toString().padLeft(2, '0'),
            price:
                "${(service.amount * service.quantity).toStringAsFixed(2)} SAR",
          );
        }),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String name;
  final String qty;
  final String price;

  const _ServiceRow({
    required this.name,
    required this.qty,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingS),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              spacing: Dimens.spacingS,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                AppText(name, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
          Expanded(
            child: AppText(
              qty,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: AppText(
              price,
              textAlign: TextAlign.right,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
