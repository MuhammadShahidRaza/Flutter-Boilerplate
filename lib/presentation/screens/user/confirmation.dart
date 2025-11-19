import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/order_details.dart';
import 'package:sanam_laundry/presentation/components/addon_card.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: "Booking Details",
      child: Column(
        spacing: Dimens.spacingM,
        children: [
          // Order ID
          BookingDetailsComp(
            details: {
              "services": [
                {"name": "Shirt Washing", "qty": "02", "price": "250 SAR"},
                {"name": "Shoe Washing", "qty": "02", "price": "250 SAR"},
                {"name": "Large Towel", "qty": "01", "price": "100 SAR"},
              ],
              "additionalNotes": TemporaryText.lorumIpsumTooLong,
              "location": "Lorem Ipsum Dr. 33, KSA",
              "pickUpDate": "30 July 2025",
              "pickUpTimeSlot": "Slot 1 (7:00 Am to 1:00 Pm)",
              "deliveryDate": "10:00 PM",
            },
          ),

          AppText(
            "Add-ons",
            style: context.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: context.h(0.15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: context.w(0.42),
                  child: AddonCard(
                    service: {"name": "Hanger", "image": AppAssets.getStarted},
                  ),
                );
              },
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // optional
            ),
          ),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: SliderComponentShape.noThumb, // ✅ Hides the thumb
              overlayShape:
                  SliderComponentShape.noOverlay, // optional: removes ripple
            ),
            child: Slider(
              value: 2.0,
              max: 10.0,
              min: 0.0,
              onChanged: (value) {},
              activeColor: AppColors.secondary,
              inactiveColor: AppColors.border,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "15 SAR remaining to qualify for free delivery",
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppIcon(
                icon: Icons.local_shipping_outlined,
                color: AppColors.primary,
              ),
            ],
          ),

          // Pricing Summary
          _PricingRow(
            label: "Subtotal",
            value: "600 SAR",
            isBold: true,
            valueColor: AppColors.primary,
          ),
          _PricingRow(label: "Hanger (Add-ons)", value: "20 SAR"),
          _PricingRow(label: "Delivery Charges", value: "15 SAR"),
          _PricingRow(label: "Tax", value: "15 SAR"),

          Divider(color: AppColors.lightGrey),
          _PricingRow(
            label: "Total",
            value: "650 SAR",
            isBold: true,
            valueColor: AppColors.primary,
          ),

          AppButton(
            title: "Place Order",
            onPressed: () {
              // context.push(const PaymentOptions());
              AppDialog.show(
                context,
                title: "Order Placed",
                imagePath: AppAssets.order,
                borderColor: AppColors.primary,
                borderWidth: 4,
                dismissible: false,
                borderRadius: Dimens.radiusL,
                imageSize: 200,
                content: Column(
                  spacing: Dimens.spacingM,
                  children: [
                    AppButton(
                      title: "View My Orders",
                      onPressed: () =>
                          context.replacePage(AppRoutes.bookingDetails),
                    ),
                    AppButton(
                      title: "Back to Home",
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                          BorderSide(color: AppColors.secondary),
                        ),
                      ),
                      textStyle: context.textTheme.bodyLarge!.copyWith(
                        color: AppColors.text,
                      ),
                      type: AppButtonType.outlined,
                      onPressed: () => context.replacePage(AppRoutes.home),
                    ),
                  ],
                ),
                backgroundColor: AppColors.tertiary,
                crossAxisAlignment: CrossAxisAlignment.center,
                insetPadding: EdgeInsets.all(Dimens.spacingXXL),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PricingRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
        AppText(
          value,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
