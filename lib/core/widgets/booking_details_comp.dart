import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
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
        if (details?["additionalNotes"] != null &&
            details?["additionalNotes"].isNotEmpty) ...[
          AppText(Common.additionalNotes, style: context.textTheme.titleMedium),
          AppText(
            Utils.capitalize(details?["additionalNotes"]),
            style: context.textTheme.bodySmall!.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 10,
          ),
        ],
        // Details Section
        if (details?["location"] != null)
          MessageBox(
            icon: Icons.location_on_outlined,
            title: Common.locationLabel,
            value: Utils.capitalize(details?["location"]),
          ),

        if (details?["deliveryType"] != null)
          MessageBox(
            icon: Icons.local_shipping_outlined,
            title: Common.selectDeliveryType,
            value: Utils.capitalize(details?["deliveryType"]),
          ),

        MessageBox(
          icon: Icons.calendar_today_outlined,

          title: Common.pickUpDate,
          value: details?["pickUpDate"],
        ),
        details?["pickUpTimeSlot"] != null
            ? MessageBox(
                icon: Icons.access_time_outlined,
                title: Common.pickUpTimeSlot,
                value: details?["pickUpTimeSlot"],
              )
            : SizedBox.shrink(),
        MessageBox(
          icon: Icons.event_outlined,
          title: Common.deliveryDate,
          value: details?["deliveryDate"],
        ),
        MessageBox(
          icon: Icons.event_outlined,
          title: Common.deliveryTimeSlot,
          value: details?["deliveryTimeSlot"],
        ),
        SizedBox(height: Dimens.spacingM),
        Divider(color: AppColors.lightGrey),
      ],
    );
  }
}
