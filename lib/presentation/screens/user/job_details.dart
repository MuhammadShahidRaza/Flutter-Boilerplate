import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/core/utils/launcher.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/rider_repositories/index.dart';
import 'package:sanam_laundry/presentation/components/service_table.dart';
import 'package:sanam_laundry/presentation/index.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool _initialized = false;
  late String bookingId;
  final RiderRepository _riderRepository = RiderRepository();

  OrderModel? orderDetails;

  Future<void> _loadOrderDetailsById() async {
    if (bookingId.isEmpty) return;
    final response = await _riderRepository.getOrderDetailsById(bookingId);
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
      return DateFormat('d MMM, yyyy').format(val);
    }
    return val?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = orderDetails?.user;

    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: Common.jobDetails,
      child: orderDetails == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              // spacing: Dimens.spacingM,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Order ID
                AppImage(
                  path: userDetails?.profileImage ?? AppAssets.user,
                  width: context.w(0.4),
                  height: context.h(0.17),
                  borderRadius: Dimens.radiusM,
                ),
                AppText(
                  Utils.getfullName(userDetails),
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      Common.orderId,
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    AppText(
                      ': ${orderDetails?.id}',
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
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
                        borderRadius: BorderRadius.circular(Dimens.radiusXxs),
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.spacingMLarge,
                  children: [
                    Column(
                      spacing: Dimens.spacingS,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          Common.additionalNotes,
                          style: context.textTheme.titleMedium,
                        ),

                        AppText(
                          (orderDetails?.specialInstructions ?? '')
                                  .trim()
                                  .isEmpty
                              ? Common.noSpecialInstructionsProvided
                              : Utils.capitalize(
                                  orderDetails?.specialInstructions,
                                ),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 10,
                        ),
                      ],
                    ),

                    // Additional Notes
                    Row(
                      spacing: Dimens.spacingS,
                      children: [
                        Expanded(
                          child: MessageBox(
                            icon: Icons.location_on_outlined,
                            title: Common.locationLabel,
                            value: Utils.capitalize(
                              orderDetails?.address ?? "",
                            ),
                            descriptionMaxLines: 10,
                          ),
                        ),

                        AppButton(
                          title: Common.viewPicture,
                          onPressed: () {
                            AppDialog.show(
                              context,
                              borderColor: AppColors.primary,
                              borderWidth: 6,
                              borderRadius: Dimens.radiusL,
                              spacing: Dimens.spacingMSmall,
                              dismissible: true,
                              content: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: Dimens.spacingM,
                                children: [
                                  Expanded(
                                    child: ImagePickerBox(
                                      initialImagePath:
                                          AppAssets.pickerPlaceholder,
                                      borderColor: AppColors.border,
                                      wantBottomSpace: false,
                                      enabled: false,
                                      title: Common.buildingPicture,
                                    ),
                                  ),
                                  Expanded(
                                    child: ImagePickerBox(
                                      initialImagePath:
                                          AppAssets.pickerPlaceholder,
                                      borderColor: AppColors.border,
                                      wantBottomSpace: false,
                                      enabled: false,
                                      title: Common.apartmentPicture,
                                    ),
                                  ),
                                ],
                              ),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              insetPadding: EdgeInsets.all(Dimens.spacingXXL),
                            );
                          },
                          padding: EdgeInsets.zero,
                          style: ButtonStyle(
                            minimumSize: WidgetStatePropertyAll(
                              Size(context.w(0.3), 32),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimens.radiusXxs,
                                ),
                              ),
                            ),
                          ),
                          textStyle: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: MessageBox(
                            icon: Icons.calendar_today_outlined,
                            title: Common.pickUpDate,
                            value: _formatDate(
                              orderDetails?.pickupDatetime ?? "",
                            ),
                          ),
                        ),

                        Expanded(
                          child: MessageBox(
                            icon: Icons.access_time_outlined,
                            title: Common.pickUpTimeSlot,
                            value:
                                '${orderDetails?.pickupSlot?.title} ( ${orderDetails?.pickupSlot?.startTime} - ${orderDetails?.pickupSlot?.endTime} )',
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: MessageBox(
                            icon: Icons.event_outlined,
                            title: Common.deliveryDate,
                            value: _formatDate(
                              orderDetails?.deliveryDatetime ?? "",
                            ),
                          ),
                        ),
                        Expanded(
                          child: MessageBox(
                            icon: Icons.event_outlined,
                            title: Common.deliveryTimeSlot,
                            // style: context.textTheme.labelSmall!.copyWith(
                            //   color: AppColors.textSecondary,
                            //   fontSize: Dimens.fontXXS,
                            // ),
                            value:
                                '${orderDetails?.deliverySlot?.title} ( ${orderDetails?.deliverySlot?.startTime} - ${orderDetails?.deliverySlot?.endTime} )',
                          ),
                        ),
                      ],
                    ),

                    MessageBox(
                      icon: Icons.local_shipping_outlined,
                      title: Common.deliveryType,
                      value: Utils.capitalize(orderDetails?.deliveryType),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          Common.orderDetails,
                          style: context.textTheme.titleLarge,
                        ),

                        ServicesTable(
                          services: (orderDetails?.bookingDetail ?? [])
                              .map(
                                (item) => CartItem(
                                  serviceId: item.service?.id ?? 0,
                                  serviceName: item.service?.title ?? '',
                                  quantity: item.quantity ?? 1,
                                  amount:
                                      double.tryParse(item.amount ?? "0") ?? 0,
                                ),
                              )
                              .toList(),
                          showCharges: false,
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: Dimens.spacingM,
                  children: [
                    AppText(
                      Common.updateStatus,
                      style: context.textTheme.titleLarge,
                    ),
                    AppButton(
                      title: orderDetails?.status ?? "",
                      onPressed: () {
                        AppDialog.show(
                          context,
                          borderColor: AppColors.primary,
                          borderWidth: 5,
                          dismissible: false,
                          borderRadius: Dimens.radiusL,
                          content: AppText(
                            Common.areYouSureYouWantToUpdateStatus,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPrimaryPressed: () => {context.back()},
                          showTwoPrimaryButtons: true,
                          primaryButtonText: Common.yes,
                          secondaryButtonText: Common.no,
                          onSecondaryPressed: () => {context.back()},
                          backgroundColor: AppColors.lightWhite,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
                        );
                      },
                      padding: EdgeInsets.zero,
                      style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size(context.w(0.6), 45),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(Common.customerPhone),
                        AppText(
                          ': ${userDetails?.phone ?? ''}',
                          onTap: () {
                            AppLauncher.openPhone(userDetails?.phone ?? '');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
