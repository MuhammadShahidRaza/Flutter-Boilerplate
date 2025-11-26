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
  final HomeRepository _homeRepository = HomeRepository();

  OrderModel? orderDetails;

  Future<void> _loadOrderDetailsById(String id) async {
    final response = await _homeRepository.getOrderDetailsById(id);
    if (response != null) {
      setState(() {
        orderDetails = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrderDetailsById("1");
  }

  String _formatDate(dynamic val) {
    if (val is DateTime) return DateFormat('EEE, d MMM').format(val);
    return val?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = true;
    final firstService = orderDetails?.bookingDetail.isNotEmpty == true
        ? orderDetails!.bookingDetail.first.service
        : null;
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
              AppText(
                "Order ID: ${orderDetails?.id ?? ''}",
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
              AppText(
                orderDetails?.status ?? '',
                style: context.textTheme.titleMedium,
              ),
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
              "services":
                  (orderDetails?.bookingDetail.map((e) => e.service).toList() ??
                          [])
                      .map(
                        (e) => CartItem(
                          serviceId: e?.id ?? 0,
                          serviceName: e?.title ?? '',
                          quantity: 1, // or e.quantity if available
                          amount: double.tryParse(e?.amount ?? "0") ?? 0,
                        ),
                      )
                      .toList(),
              "additionalNotes": orderDetails?.specialInstructions ?? "",
              "location": orderDetails?.address ?? "",
              "deliveryType": orderDetails?.deliveryType ?? "",
              "pickUpDate": _formatDate(orderDetails?.pickupDatetime ?? ""),
              "pickUpTimeSlot": orderDetails?.pickupSlotId ?? "",
              "deliveryDate": _formatDate(orderDetails?.deliveryDatetime),
              "deliveryTimeSlot": orderDetails?.deliverySlotId ?? "",
            },
          ),
          // Pricing Summary
          _PricingRow(
            label: "Subtotal",
            value: "${orderDetails?.subTotal ?? ''} SAR",
            isBold: true,
            valueColor: AppColors.primary,
          ),
          // _PricingRow(label: "Hanger (Add-ons)", value: "20 SAR"),
          _PricingRow(label: "Tax", value: "${orderDetails?.tax ?? ''} SAR"),
          Divider(color: AppColors.lightGrey),
          _PricingRow(
            label: "Total",
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
