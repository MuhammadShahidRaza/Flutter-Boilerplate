import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/presentation/index.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = order.status == "completed";
    final firstService = order.bookingDetail.isNotEmpty
        ? order.bookingDetail.first.service
        : null;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
      child: InkWell(
        onTap: () {
          context.navigate(AppRoutes.bookingDetails);
        },
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingS),
          child: Column(
            spacing: Dimens.spacingMSmall,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.spacingMSmall,
                children: [
                  AppImage(
                    path: firstService?.image ?? AppAssets.user,
                    width: context.w(0.30),
                    height: context.h(0.15),
                    borderRadius: Dimens.radiusS,
                  ),
                  Expanded(
                    child: Column(
                      spacing: Dimens.spacingXS,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          firstService?.title ?? "Service Title",
                          style: context.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppText(
                          "Order ID: ${order.id}",
                          style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        AppText(
                          order.specialInstructions.isNotEmpty
                              ? order.specialInstructions
                              : "No special instructions provided.",
                          maxLines: 2,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: AppColors.gray,
                          ),
                        ),

                        AppButton(
                          title: order.status,
                          onPressed: () {},
                          backgroundColor: isCompleted
                              ? AppColors.secondary
                              : AppColors.primary.withValues(alpha: 0.3),
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
                            "Location:",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: context.w(0.40),
                            child: AppText(
                              order.address ?? "",
                              style: context.textTheme.bodySmall!.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (order.paymentStatus == "pending") ...[
                    AppButton(
                      title: "Pay Now",
                      textStyle: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size(context.w(0.1), 36),
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
                              "Order Time:",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: context.w(0.25),
                              child: AppText(
                                "8:00 AM",
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
