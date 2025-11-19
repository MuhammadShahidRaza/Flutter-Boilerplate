import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/order_details.dart';
import 'package:sanam_laundry/core/widgets/stepper.dart';
import 'package:sanam_laundry/presentation/index.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = true;
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: "Booking Details",
      child: Column(
        spacing: Dimens.spacingM,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          AppImage(
            path: AppAssets.temp,
            width: context.screenWidth,
            height: context.h(0.3),
            borderRadius: Dimens.radiusM,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Washing",
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                "Order ID: 2458",
                style: context.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Status Stepper
          Row(
            spacing: Dimens.spacingM,
            children: [
              AppText("Status", style: context.textTheme.titleMedium),
              if (isCompleted)
                AppButton(
                  title: "Completed",
                  onPressed: () {},
                  backgroundColor: AppColors.secondary,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.spacingXS,
                    horizontal: Dimens.spacingS,
                  ),
                  textStyle: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(context.w(0.22), 25),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXxs),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          HorizontalStepper(
            currentStep: 2,
            steps: const [
              "Order Received",
              "Processing",
              "Order ready - awaiting Payment",
              "Out for Delivery",
              "Delivered",
            ],
          ),

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
          // Pricing Summary
          _PricingRow(
            label: "Subtotal",
            value: "600 SAR",
            isBold: true,
            valueColor: AppColors.primary,
          ),
          _PricingRow(label: "Hanger (Add-ons)", value: "20 SAR"),
          _PricingRow(label: "Tax", value: "15 SAR"),
          Divider(color: AppColors.lightGrey),
          _PricingRow(
            label: "Total",
            value: "635 SAR",
            isBold: true,
            valueColor: AppColors.primary,
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
