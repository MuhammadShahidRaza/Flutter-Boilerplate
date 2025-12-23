import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/presentation/components/months_date_listing.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

enum DeliveryType { normal, express }

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // Use provider caches instead of local lists

  DeliveryType deliveryType = DeliveryType.normal;
  AddressModel? selectedAddress;
  DateTime? selectedPickUpDate;
  DateTime? selectedDeliveryDate;
  String selectedPickUpSlotId = '';
  String selectedDeliverySlotId = '';
  String selectedServiceType = 'pickup'; // 'pickup' or 'delivery'

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prime provider caches once per session
    final prov = context.read<ServicesProvider>();
    prov.ensureAddresses();
    prov.ensureSlots();
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: Common.orderDetails,
      child: Column(
        spacing: Dimens.spacingM,
        children: [
          // Order ID
          AppInput(
            controller: controller,
            enabled: false,
            title: Common.location,
            hint: Common.selectAddressFromOptions,
            suffixIcon: AppIcon(
              icon: Icons.add,
              size: Dimens.iconL,
              onTap: () => context.navigate(AppRoutes.myAddress),
            ),
          ),

          Consumer<ServicesProvider>(
            builder: (context, provider, child) {
              final addresses = provider.addresses;

              if (addresses.isEmpty) return SizedBox.shrink();

              return SizedBox(
                height: 40,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: Dimens.spacingS),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final addressItem = addresses[index];
                    final isSelected = selectedAddress?.id == addressItem.id;

                    return AppButton(
                      title: addressItem.label ?? 'Address ${addressItem.id}',
                      type: AppButtonType.outlined,
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                      textStyle: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.white : AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.text = Utils.capitalize(
                            addressItem.address ?? '',
                          );
                          selectedAddress = addressItem;
                        });
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size(context.w(0.25), 25),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimens.radiusXL,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          AppDropdown(
            title: Common.selectDeliveryType,
            hint: Common.normal48Hours,
            value: deliveryType == DeliveryType.express
                ? Common.express24Hours
                : Common.normal48Hours,
            items: [Common.normal48Hours, Common.express24Hours],
            onChanged: (value) {
              setState(() {
                deliveryType = value == Common.express24Hours
                    ? DeliveryType.express
                    : DeliveryType.normal;
              });
            },
          ),
          if (deliveryType == DeliveryType.express)
            AppText(
              Common.noteAdditionalChargesExpress,
              textAlign: TextAlign.center,
              color: AppColors.secondary,
            ),
          Divider(color: AppColors.border),

          // Row(
          //   children: [
          //     Expanded(
          //       child: AppRadioItem<String>(
          //         value: "pickup",
          //         groupValue: selectedServiceType,
          //         label: "Pickup",
          //         onChanged: (val) {
          //           setState(() => selectedServiceType = val);
          //         },
          //         labelStyle: context.textTheme.titleMedium!.copyWith(
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: AppRadioItem<String>(
          //         value: "delivery",
          //         groupValue: selectedServiceType,
          //         label: "Delivery",
          //         onChanged: (val) {
          //           setState(() => selectedServiceType = val);
          //         },
          //         labelStyle: context.textTheme.titleMedium!.copyWith(
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          MonthsDateListing(
            slots: context.watch<ServicesProvider>().slots,
            heading: Common.selectPickUpDateTime,
            onDateSelected: (date) {
              setState(() {
                selectedPickUpDate = date;
                selectedDeliveryDate = null;
                selectedDeliverySlotId = '';
              });
            },
            showSlots: selectedPickUpDate != null,
            onSlotSelected: (slotId) {
              setState(() {
                selectedPickUpSlotId = slotId;
              });
            },
          ),

          if (selectedPickUpDate != null && selectedPickUpSlotId.isNotEmpty)
            MonthsDateListing(
              slots: context.watch<ServicesProvider>().slots,
              heading: Common.selectDeliveryDateTime,
              onDateSelected: (date) {
                setState(() {
                  selectedDeliveryDate = date;
                });
              },
              showSlots: selectedDeliveryDate != null,
              disabledExtraDays: deliveryType == DeliveryType.express ? 1 : 2,
              baseDate:
                  selectedPickUpDate, // delivery can only start after pickup + extra days
              onSlotSelected: (slotId) {
                setState(() {
                  selectedDeliverySlotId = slotId;
                });
              },
            ),
          SizedBox(height: Dimens.spacingM),
          AppButton(
            title: Common.placeOrder,
            isEnabled:
                selectedPickUpDate != null &&
                selectedPickUpSlotId.isNotEmpty &&
                selectedDeliveryDate != null &&
                selectedDeliverySlotId.isNotEmpty &&
                selectedAddress != null,
            onPressed: () {
              final cart = context.read<CartProvider>();

              final pickupDateStr = DateFormat(
                'yyyy-MM-dd',
              ).format(selectedPickUpDate!);
              final deliveryDateStr = DateFormat(
                'yyyy-MM-dd',
              ).format(selectedDeliveryDate!);
              cart.addOrderDetail(
                "delivery_type",
                deliveryType == DeliveryType.express ? "express" : "normal",
              );

              cart.addOrderDetail("pickup_datetime", pickupDateStr);
              cart.addOrderDetail("pickup_slot_id", selectedPickUpSlotId);
              cart.addOrderDetail("delivery_datetime", deliveryDateStr);
              cart.addOrderDetail("delivery_slot_id", selectedDeliverySlotId);
              cart.addOrderDetail("address", selectedAddress?.address ?? "");
              cart.addOrderDetail("city", selectedAddress?.city ?? "");
              cart.addOrderDetail(
                "building_image_url",
                selectedAddress?.buildingImage ?? "",
              );
              cart.addOrderDetail(
                "apartment_image_url",
                selectedAddress?.apartmentImage ?? "",
              );
              cart.addOrderDetail("state", selectedAddress?.state ?? "");
              cart.addOrderDetail("latitude", selectedAddress?.latitude ?? "");
              cart.addOrderDetail(
                "longitude",
                selectedAddress?.longitude ?? "",
              );
              cart.addOrderDetail("service_type", selectedServiceType);
              context.navigate(AppRoutes.additionalInformation);
            },
          ),
        ],
      ),
    );
  }
}
