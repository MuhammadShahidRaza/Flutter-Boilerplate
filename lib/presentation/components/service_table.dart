import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/presentation/index.dart';

class ServicesTable extends StatelessWidget {
  final List<CartItem> services;
  final bool showCharges;
  const ServicesTable({
    super.key,
    required this.services,
    this.showCharges = true,
  });

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
                  Common.services,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AppText(
                  Common.qty,
                  textAlign: showCharges ? TextAlign.center : TextAlign.right,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showCharges)
                Expanded(
                  child: AppText(
                    Common.charges,
                    textAlign: TextAlign.left,
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
            showCharges: showCharges,
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
  final bool showCharges;

  const _ServiceRow({
    required this.name,
    required this.qty,
    required this.price,
    this.showCharges = true,
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
                Expanded(
                  child: AppText(
                    name,
                    style: context.textTheme.bodyMedium,
                    // maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppText(
              qty,
              textAlign: showCharges ? TextAlign.center : TextAlign.right,
              style: context.textTheme.bodyMedium,
            ),
          ),
          if (showCharges)
            Expanded(
              child: AppText(
                price,
                textAlign: TextAlign.left,
                style: context.textTheme.bodyMedium!.copyWith(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
