import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/radio_button.dart';
import 'package:sanam_laundry/presentation/components/months_date_listing.dart';
import 'package:sanam_laundry/presentation/index.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  DateTime? selectedDate;
  String selectedSlotId = '';
  String selectedServiceType = 'pickup'; // 'pickup' or 'delivery'

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> address = [
      {
        "id": "1",
        "type": "Home",
        "details": "123 Main St, Springfield, IL 62701",
      },
      {
        "id": "2",
        "type": "Work",
        "details": "456 Elm St, Springfield, IL 62702",
      },
    ];
    final List<Map<String, String>> slots = [
      {"id": "1", "details": "7pm to 9pm"},
      {"id": "2", "details": "9pm to 11pm"},
    ];
    final TextEditingController controller = TextEditingController(
      text: TemporaryText.lorumIpsum,
    );

    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: "Order Details",
      child: Column(
        spacing: Dimens.spacingM,
        children: [
          // Order ID
          AppInput(
            controller: controller,
            enabled: false,
            // title: Common.address,
            title: "Address",
          ),

          SizedBox(
            height: 40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) =>
                  SizedBox(width: Dimens.spacingS),
              itemCount: address.length,
              itemBuilder: (context, index) {
                final addressItem = address[index];
                return AppButton(
                  title: addressItem["type"],
                  type: AppButtonType.outlined,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  textStyle: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(context.w(0.25), 25),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXL),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          AppDropdown(
            title: "Select Delivery Type",
            hint: "Normal (24 Hours)",
            items: ["Option 1", "Option 2", "Option 3"],
            onChanged: (value) {},
          ),
          AppText(
            "Note: Additional charges for express delivery.",
            textAlign: TextAlign.center,
            color: AppColors.secondary,
          ),
          Divider(color: AppColors.border),

          Row(
            children: [
              Expanded(
                child: AppRadioItem<String>(
                  value: "pickup",
                  groupValue: selectedServiceType,
                  label: "Pickup",
                  onChanged: (val) {
                    setState(() => selectedServiceType = val);
                  },
                  labelStyle: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AppRadioItem<String>(
                  value: "delivery",
                  groupValue: selectedServiceType,
                  label: "Delivery",
                  onChanged: (val) {
                    setState(() => selectedServiceType = val);
                  },
                  labelStyle: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (selectedServiceType == 'pickup')
            MonthsDateListing(
              slots: slots,
              heading: "Select Pick-up Date & Time",
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              onSlotSelected: (slotId) {
                setState(() {
                  selectedSlotId = slotId;
                });
              },
            ),

          if (selectedServiceType == 'delivery')
            MonthsDateListing(
              slots: slots,
              heading: "Select Delivery Date & Time",
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              onSlotSelected: (slotId) {
                setState(() {
                  selectedSlotId = slotId;
                });
              },
            ),
          SizedBox(height: Dimens.spacingM),
          AppButton(
            // title: Common.orderNow,
            isEnabled: selectedDate != null && selectedSlotId.isNotEmpty,
            title: "Order Now",
            onPressed: () {
              context.navigate(AppRoutes.additionalInformation);
            },
          ),
        ],
      ),
    );
  }
}
