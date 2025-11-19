import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/presentation/components/service_table.dart';
import 'package:sanam_laundry/presentation/index.dart';

class BookingDetailsComp extends StatelessWidget {
  final dynamic details;
  const BookingDetailsComp({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacingM,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Services Section
        ServicesTable(services: details?["services"]),

        // Additional Notes
        AppText("Additional Notes:", style: context.textTheme.titleMedium),

        AppText(
          details?["additionalNotes"] ?? TemporaryText.lorumIpsumTooLong,
          style: context.textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary,
          ),
          maxLines: 10,
        ),

        // Details Section
        MessageBox(
          icon: Icons.location_on_outlined,
          title: "Location:",
          value: details?["location"],
        ),
        MessageBox(
          icon: Icons.local_shipping_outlined,
          title: "Delivery Type:",
          value: "Normal",
        ),
        MessageBox(
          icon: Icons.calendar_today_outlined,
          title: "Pick-up Date:",
          value: details?["pickUpDate"],
        ),
        MessageBox(
          icon: Icons.access_time_outlined,
          title: "Pick-up Time Slot:",
          value: details?["pickUpTimeSlot"],
        ),
        MessageBox(
          icon: Icons.event_outlined,
          title: "Delivery Date:",
          value: details?["deliveryDate"],
        ),

        SizedBox(height: Dimens.spacingM),
        Divider(color: AppColors.lightGrey),
      ],
    );
  }
}
