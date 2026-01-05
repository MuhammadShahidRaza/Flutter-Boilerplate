import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/core/utils/launcher.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/rider_repositories/index.dart';
import 'package:sanam_laundry/presentation/components/service_table.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/presentation/screens/rider/my_jobs.dart';
import 'package:sanam_laundry/providers/index.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool _initialized = false;
  late String bookingId;
  final RiderRepository _riderRepository = RiderRepository();
  VoidCallback? onOrderUpdated;

  OrderModel? orderDetails;
  XFile? imageFile;

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
      bookingId = context.getExtra<Map<String, dynamic>>()?["id"] ?? '';
      onOrderUpdated = context.getExtra()?["onUpdateStatus"];
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

  Future<OrderModel?> updateOrderStatus(status) async {
    final response = await _riderRepository.updateOrderStatus(
      status: status,
      id: orderDetails!.id!.toString(),
      image: imageFile,
    );

    if (response != null) {
      setState(() => orderDetails = response);
      return response;
    }
    return null;
  }

  void onPressed(status) async {
    if (context.read<UserProvider>().user?.isRiderActive == false) {
      AppToast.showToast(
        "You are currently inactive. Please go active to proceed.",
      );
      return;
    }

    if (status == "Order Delivered" && imageFile == null) {
      AppToast.showToast(
        "Please upload an image before marking the order as delivered.",
      );
      return;
    }

    final updatedOrder = await updateOrderStatus(status);
    if (updatedOrder != null) {
      if (status == "Order Delivered") {
        if (!mounted) return;
        AppDialog.show(
          context,
          title: Common.jobDone,
          imagePath: AppAssets.allSet,
          borderColor: AppColors.primary,
          borderWidth: 4,
          dismissible: false,
          borderRadius: Dimens.radiusL,
          imageSize: 150,
          content: AppText(
            maxLines: 3,
            textAlign: TextAlign.center,
            Auth.soonYouWillRecieve,
          ),
          primaryButtonText: Common.okay,
          onPrimaryPressed: () => {
            onOrderUpdated?.call(),
            if (mounted) context.back(),
            if (mounted) context.back(),
          },
          backgroundColor: AppColors.lightWhite,
          crossAxisAlignment: CrossAxisAlignment.center,
          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
        );
      } else {
        onOrderUpdated?.call();
        if (!mounted) return;
        context.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = orderDetails?.user;
    final isCompleted =
        context.getExtra<Map<String, dynamic>>()?["tabType"] ==
        JobStatus.completed.label;
    final tabType = context.getExtra<Map<String, dynamic>>()?["tabType"] ?? '';
    return AppWrapper(
      showBackButton: true,
      scrollable: true,
      heading: Common.jobDetails,
      child: orderDetails == null
          ? const BookingDetailSkeleton()
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
                      ': ${orderDetails?.orderNumber ?? ""}',
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                if (tabType.isNotEmpty)
                  AppButton(
                    title: tabType,
                    onPressed: null,
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
                            onTap: () {
                              AppLauncher.openLink(
                                'https://www.google.com/maps/search/?api=1&query=${orderDetails?.latitude},${orderDetails?.longitude}',
                              );
                            },
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
                                          orderDetails?.buildingImage ??
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
                                          orderDetails?.appartmentImage ??
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

                if (orderDetails?.nextStatus == "Order Delivered" &&
                    !isCompleted)
                  ImagePickerBox(
                    initialImagePath: AppAssets.pickerPlaceholder,
                    title: Common.uploadDeliveryImage,
                    onImagePicked: (file) {
                      setState(() => imageFile = file);
                    },
                  ),
                if (!isCompleted)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: Dimens.spacingM,
                    children: [
                      AppText(
                        Common.updateStatus,
                        style: context.textTheme.titleLarge,
                      ),
                      AppButton(
                        title: orderDetails?.nextStatus ?? "",
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
                            onPrimaryPressed: () => {
                              onPressed(orderDetails?.nextStatus),
                              context.back(),
                            },
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

                      if (orderDetails?.nextStatus == "Arrived For Pick-up" ||
                          orderDetails?.nextStatus == "Order Delivered")
                        AppButton(
                          title: Common.unsuccessfullAttempt,
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
                              onPrimaryPressed: () => {
                                onPressed("Unsuccessful Attempt"),
                                context.back(),
                              },
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
                          backgroundColor: AppColors.bottomTabText,
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
