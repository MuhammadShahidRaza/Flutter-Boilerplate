import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/booking_details_comp.dart';
import 'package:sanam_laundry/core/widgets/stepper.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool _initialized = false;
  late String bookingId;
  final HomeRepository _homeRepository = HomeRepository();

  OrderModel? orderDetails;

  Future<void> _loadOrderDetailsById() async {
    if (bookingId.isEmpty) return;
    final response = await _homeRepository.getOrderDetailsById(bookingId);
    if (response != null) {
      setState(() {
        orderDetails = response;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      bookingId = context.getExtra<String>() ?? '';
      _initialized = true;
      _loadOrderDetailsById();
    }
  }

  String _formatDate(dynamic val) {
    if (val is DateTime) {
      return DateFormat('d MMMM, yyyy').format(val);
    }
    return val?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = orderDetails?.status == 'Order Delivered';
    final firstService = orderDetails?.bookingDetail.isNotEmpty == true
        ? orderDetails!.bookingDetail.first.service
        : null;

    int currentIndex =
        orderDetails?.statusList.indexOf(orderDetails?.status ?? '') ?? 0;

    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: Common.bookingDetails,
      child: orderDetails == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              spacing: Dimens.spacingM,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                AppImage(
                  path: firstService?.image ?? AppAssets.user,
                  width: context.screenWidth,
                  height: context.h(0.3),
                  borderRadius: Dimens.radiusM,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      firstService?.title ?? '',
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        AppText(
                          Common.orderId,
                          style: context.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        AppText(
                          ': ${orderDetails?.orderNumber ?? ""}',
                          style: context.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Status Stepper
                Row(
                  spacing: Dimens.spacingM,
                  children: [
                    AppText(
                      Common.status,
                      style: context.textTheme.titleMedium,
                    ),
                    if (isCompleted)
                      AppButton(
                        title: Common.completed,
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
                              borderRadius: BorderRadius.circular(
                                Dimens.radiusXxs,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                HorizontalStepper(
                  currentStep: currentIndex,
                  steps: orderDetails?.statusList ?? [],
                ),

                BookingDetailsComp(
                  details: {
                    // "services":
                    //     (orderDetails?.bookingDetail
                    //                 .map((e) => e.service)
                    //                 .toList() ??
                    //             [])
                    //         .map(
                    //           (e) => CartItem(
                    //             serviceId: e?.id ?? 0,
                    //             serviceName: e?.title ?? '',
                    //             quantity: 1, // or e.quantity if available
                    //             amount: double.tryParse(e?.amount ?? "0") ?? 0,
                    //           ),
                    //         )
                    //         .toList(),
                    "services": (orderDetails?.bookingDetail ?? [])
                        .map(
                          (item) => CartItem(
                            serviceId: item.service?.id ?? 0,
                            serviceName: item.service?.title ?? '',
                            quantity: item.quantity ?? 1,
                            amount: double.tryParse(item.amount ?? "0") ?? 0,
                          ),
                        )
                        .toList(),

                    "additionalNotes": orderDetails?.specialInstructions ?? "",
                    "location": orderDetails?.address ?? "",
                    "deliveryType": orderDetails?.deliveryType ?? "",
                    "pickUpDate": _formatDate(
                      orderDetails?.pickupDatetime ?? "",
                    ),
                    "pickUpTimeSlot":
                        '${orderDetails?.pickupSlot?.title} ( ${orderDetails?.pickupSlot?.startTime} - ${orderDetails?.pickupSlot?.endTime} )',
                    "deliveryDate": _formatDate(orderDetails?.deliveryDatetime),
                    "deliveryTimeSlot":
                        '${orderDetails?.deliverySlot?.title} ( ${orderDetails?.deliverySlot?.startTime} - ${orderDetails?.deliverySlot?.endTime} )',
                  },
                ),
                // Pricing Summary
                _PricingRow(
                  label: Common.subtotal,
                  value:
                      "${(double.parse(orderDetails?.subTotal ?? "0") - double.parse(orderDetails?.tax ?? "0")).toStringAsFixed(2)} SAR",
                  isBold: true,
                  valueColor: AppColors.primary,
                ),
                // _PricingRow(label: "Hanger (Add-ons)", value: "20 SAR"),
                _PricingRow(
                  label: Common.tax,
                  value: "${orderDetails?.tax ?? ''} SAR",
                ),
                _PricingRow(
                  label: Common.deliveryCharges,
                  value: "${orderDetails?.deliveryCharges ?? ''} SAR",
                ),
                Divider(color: AppColors.lightGrey),
                _PricingRow(
                  label: Common.total,
                  value: "${orderDetails?.totalAmount ?? ''} SAR",
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
