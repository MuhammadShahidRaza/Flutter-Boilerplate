import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/booking_details_comp.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/components/addon_card.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final HomeRepository _homeRepository = HomeRepository();
  List<ServiceItemModel> addOnsList = [];

  void fetchAdditionalInfo() async {
    final data = await _homeRepository.getServicesByCategoryId(
      null,
      type: "addons",
    );
    if (data != null) {
      setState(() {
        addOnsList = data;
      });
    }
  }

  String _formatDate(dynamic val) {
    if (val is DateTime) return DateFormat('EEE, d MMM').format(val);
    return val?.toString() ?? '';
  }

  String _slotLabelById(List<SlotModel> slots, dynamic id) {
    if (id == null) return '';
    final sid = id.toString();
    SlotModel? match;
    for (final s in slots) {
      if (s.id.toString() == sid) {
        match = s;
        break;
      }
    }
    if (match == null) return sid;
    final title = match.title ?? 'Slot';
    final start = match.startTime ?? '';
    final end = match.endTime ?? '';
    return "$title ($start - $end)";
  }

  final Map<String, int?> selectedOptionIds = {};

  @override
  void initState() {
    super.initState();
    fetchAdditionalInfo();
    // Warm slots cache; no-op if already loaded
    context.read<ServicesProvider>().ensureSlots();
  }

  @override
  Widget build(BuildContext context) {
    final cartDetails = context.read<CartProvider>();
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: "Confirmation",
      child: Column(
        spacing: Dimens.spacingM,
        children: [
          // Order ID
          Consumer<ServicesProvider>(
            builder: (context, sp, _) => BookingDetailsComp(
              details: {
                "services": cartDetails.items,
                "additionalNotes":
                    cartDetails.orderItemsPayload['special_instructions'] ?? "",
                "location": cartDetails.orderItemsPayload['address'] ?? "",
                "deliveryType":
                    cartDetails.orderItemsPayload['delivery_type'] ?? "",
                "pickUpDate": _formatDate(
                  cartDetails.orderItemsPayload['pickup_datetime'],
                ),
                "pickUpTimeSlot": _slotLabelById(
                  sp.slots,
                  cartDetails.orderItemsPayload['pickup_slot_id'],
                ),
                "deliveryTimeSlot": _slotLabelById(
                  sp.slots,
                  cartDetails.orderItemsPayload['delivery_slot_id'],
                ),
                "deliveryDate": _formatDate(
                  cartDetails.orderItemsPayload['delivery_datetime'],
                ),
              },
            ),
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
              itemCount: addOnsList.length,
              itemBuilder: (context, index) {
                final addon = addOnsList[index];

                return SizedBox(
                  width: context.w(0.42),
                  child: AddonCard(service: addon),
                );
              },
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // optional
            ),
          ),

          Consumer2<CartProvider, ServicesProvider>(
            builder: (context, cart, sp, _) {
              if (cart.items.isEmpty) return SizedBox.shrink();

              final totalAmount = cart.totalAmount;
              final addons = cart.addOns;

              final settings = sp.settings;
              final freeDelivery = settings.freeDeliveryThreshold;
              final remaining = (freeDelivery - totalAmount).clamp(
                0,
                freeDelivery,
              );
              final isFreeDelivery = totalAmount >= freeDelivery;
              final deliveryCharges = isFreeDelivery
                  ? 0
                  : cart.orderItemsPayload['delivery_type'] == 'express'
                  ? settings.expressDelivery
                  : settings.normalDelivery;

              final tax = (settings.taxPercentage * totalAmount) / 100;
              final newTotalAmount = totalAmount + deliveryCharges + tax;

              return Column(
                spacing: Dimens.spacingM,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: SliderComponentShape.noThumb,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: totalAmount.clamp(0, freeDelivery).toDouble(),
                      max: freeDelivery.toDouble(),
                      min: 0,
                      onChanged: (_) {},
                      activeColor: AppColors.secondary,
                      inactiveColor: AppColors.border,
                    ),
                  ),
                  Row(
                    spacing: Dimens.spacingM,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          isFreeDelivery
                              ? "You qualify for free delivery 🎉"
                              : "${remaining.toStringAsFixed(2)} SAR remaining to qualify for free delivery",
                          maxLines: 2,
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
                    value: "${totalAmount.toStringAsFixed(2)} SAR",
                    isBold: true,
                    valueColor: AppColors.primary,
                  ),
                  if (addons.isNotEmpty)
                    _PricingRow(
                      label: "Add-ons",
                      value: "${cart.totalAddonsAmount.toStringAsFixed(2)} SAR",
                    ),
                  _PricingRow(
                    label: "Delivery Charges",
                    value: "$deliveryCharges SAR",
                  ),
                  _PricingRow(
                    label: "Tax",
                    value: "${tax.toStringAsFixed(2)} SAR",
                  ),

                  Divider(color: AppColors.lightGrey),
                  _PricingRow(
                    label: "Total",
                    value: "${newTotalAmount.toStringAsFixed(2)} SAR",
                    isBold: true,
                    valueColor: AppColors.primary,
                  ),

                  AppButton(
                    title: "Place Order",
                    onPressed: () async {
                      final payload = cart.toOrderPayload();
                      final response = await _homeRepository.placeOrder(
                        payload: payload,
                      );

                      if (response != null) {
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
                                onPressed: () => context.replacePage(
                                  AppRoutes.bookingDetails,
                                  extra: response?.id?.toString(),
                                ),
                              ),
                              AppButton(
                                title: "Back to Home",
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(color: AppColors.secondary),
                                  ),
                                ),
                                textStyle: context.textTheme.bodyLarge!
                                    .copyWith(color: AppColors.text),
                                type: AppButtonType.outlined,
                                onPressed: () =>
                                    context.replacePage(AppRoutes.home),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.tertiary,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
                        );
                      }
                    },
                  ),
                ],
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
