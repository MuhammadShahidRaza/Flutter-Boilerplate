import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/presentation/screens/rider/index.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.order,
    required this.type,
    this.tabType,
    this.onTap,
  });

  final OrderModel order;
  final String type;
  final String? tabType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDeliveryType = type == "delivery";
    final userDetails = order.user;
    final isCompleted = tabType == JobStatus.completed.label;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
      child: InkWell(
        onTap:
            onTap ??
            () {
              context.navigate(
                AppRoutes.jobDetails,
                extra: {"id": order.id.toString(), "tabType": tabType},
              );
            },
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingS),
          child: Column(
            spacing: Dimens.spacingS,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.spacingMSmall,
                children: [
                  AppImage(
                    path: order.user?.profileImage ?? AppAssets.user,
                    width: context.w(0.30),
                    height: context.h(0.13),
                    borderRadius: Dimens.radiusS,
                  ),
                  Expanded(
                    child: Column(
                      spacing: order.specialInstructions.isEmpty
                          ? Dimens.spacingXS
                          : 0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          Utils.getfullName(userDetails),
                          style: context.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            AppText(
                              Common.orderId,
                              style: context.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            AppText(
                              ': ${order.orderNumber ?? ""}',
                              style: context.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          order.specialInstructions.isNotEmpty
                              ? order.specialInstructions
                              : Common.noSpecialInstructionsProvided,
                          maxLines: 2,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: AppColors.gray,
                          ),
                        ),

                        if (isCompleted) ...[
                          AppButton(
                            title: isCompleted
                                ? Common.completed
                                : order.status,
                            onPressed: () {},
                            backgroundColor:
                                //  isDeliveryType
                                // ?
                                AppColors.secondary,
                            // : AppColors.primary.withValues(alpha: 0.3),
                            padding: EdgeInsets.symmetric(
                              vertical: Dimens.spacingXS,
                              horizontal: Dimens.spacingS,
                            ),
                            isEnabled: false,
                            textStyle: context.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(
                                Size(context.w(0.22), 30),
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
                        ] else ...[
                          Row(
                            spacing: Dimens.spacingS,
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: order.status,
                                  onPressed: () {},
                                  backgroundColor:
                                      //  isDeliveryType
                                      // ?
                                      AppColors.secondary,
                                  // : AppColors.primary.withValues(alpha: 0.3),
                                  isEnabled: false,
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimens.spacingXS,
                                    horizontal: Dimens.spacingS,
                                  ),
                                  textStyle: context.textTheme.bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                  style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(
                                      Size(context.w(0.22), 30),
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
                              ),

                              Expanded(
                                child: AppButton(
                                  title: isDeliveryType
                                      ? Common.deliveryOrder
                                      : Common.pickUpOrder,
                                  onPressed: () {},
                                  backgroundColor:
                                      //  isDeliveryType
                                      // ? AppColors.secondary
                                      // :
                                      AppColors.primary.withValues(alpha: 0.5),
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimens.spacingXS,
                                    horizontal: Dimens.spacingS,
                                  ),
                                  textStyle: context.textTheme.bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                  isEnabled: false,
                                  style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(
                                      Size(context.w(0.22), 30),
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
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Dimens.spacingXS,
                    children: [
                      AppIcon(
                        icon: Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            Common.locationLabel,
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: context.w(0.35),
                            child: AppText(
                              order.address ?? "",
                              style: context.textTheme.labelSmall!.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Dimens.spacingXS,
                    children: [
                      AppIcon(
                        icon: Icons.timer_sharp,
                        color: AppColors.primary,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            isDeliveryType
                                ? Common.deliveryTimeSlot
                                : Common.pickUpTimeSlot,
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: context.w(0.35),
                            child: AppText(
                              isDeliveryType
                                  ? '${order.deliverySlot?.title} ( ${order.deliverySlot?.startTime} - ${order.deliverySlot?.endTime} )'
                                  : '${order.pickupSlot?.title} ( ${order.pickupSlot?.startTime} - ${order.pickupSlot?.endTime} )',
                              style: context.textTheme.labelSmall!.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: Dimens.fontXXS,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
