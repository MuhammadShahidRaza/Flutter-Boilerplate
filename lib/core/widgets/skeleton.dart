import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/theme/colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const SkeletonLoader({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? (borderRadius ?? BorderRadius.circular(8))
              : null,
        ),
      ),
    );
  }
}

// Order Card Skeleton
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacingM),
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingM,
        children: [
          SkeletonLoader(
            height: 80,
            width: 80,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.spacingS,
              children: [
                SkeletonLoader(
                  height: 16,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(4),
                ),
                SkeletonLoader(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.4,
                  borderRadius: BorderRadius.circular(4),
                ),
                SkeletonLoader(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.3,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Notification Card Skeleton
class NotificationCardSkeleton extends StatelessWidget {
  const NotificationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SkeletonLoader(height: 50, width: 50, shape: BoxShape.circle),
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SkeletonLoader(
                height: 14,
                width: double.infinity,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            SkeletonLoader(
              height: 12,
              width: 50,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.spacingS,
          children: [
            const SizedBox(height: 8),
            SkeletonLoader(
              height: 12,
              width: double.infinity,
              borderRadius: BorderRadius.circular(4),
            ),
            SkeletonLoader(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.7,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

// Generic List Skeleton
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget skeletonItem;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const ListSkeleton({
    super.key,
    this.itemCount = 6,
    required this.skeletonItem,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => skeletonItem,
    );
  }
}

// Detail Page Skeleton (for static pages with text content)
class DetailPageSkeleton extends StatelessWidget {
  const DetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingM,
        children: [
          // Title
          SkeletonLoader(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: Dimens.spacingS),
          // Paragraph lines
          ...List.generate(
            15,
            (index) => SkeletonLoader(
              height: 14,
              width: index % 5 == 0
                  ? MediaQuery.of(context).size.width * 0.7
                  : double.infinity,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

// Booking Detail Page Skeleton (for pages with image and content)
class BookingDetailSkeleton extends StatelessWidget {
  const BookingDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingM,
        children: [
          // Image section
          SkeletonLoader(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          // Title and Order ID row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(
                height: 24,
                width: MediaQuery.of(context).size.width * 0.4,
                borderRadius: BorderRadius.circular(4),
              ),
              SkeletonLoader(
                height: 18,
                width: MediaQuery.of(context).size.width * 0.3,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          // Status section
          Row(
            children: [
              SkeletonLoader(
                height: 18,
                width: 60,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: Dimens.spacingM),
              SkeletonLoader(
                height: 25,
                width: 80,
                borderRadius: BorderRadius.circular(Dimens.radiusXxs),
              ),
            ],
          ),
          // Stepper placeholder
          SkeletonLoader(
            height: 60,
            width: double.infinity,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          // Details section
          SkeletonLoader(
            height: 200,
            width: double.infinity,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          // Pricing rows
          ...List.generate(
            5,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.4,
                  borderRadius: BorderRadius.circular(4),
                ),
                SkeletonLoader(
                  height: 16,
                  width: 80,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Address Card Skeleton (for my_address list)
class AddressCardSkeleton extends StatelessWidget {
  const AddressCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacingMLarge),
      padding: const EdgeInsets.all(Dimens.spacingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingS,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(
                height: 18,
                width: 120,
                borderRadius: BorderRadius.circular(4),
              ),
              Row(
                spacing: Dimens.spacingS,
                children: [
                  SkeletonLoader(height: 24, width: 24, shape: BoxShape.circle),
                  SkeletonLoader(height: 24, width: 24, shape: BoxShape.circle),
                ],
              ),
            ],
          ),
          SkeletonLoader(
            height: 14,
            width: double.infinity,
            borderRadius: BorderRadius.circular(4),
          ),
          SkeletonLoader(
            height: 14,
            width: MediaQuery.of(context).size.width * 0.7,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

// Payment Page Skeleton
class PaymentPageSkeleton extends StatelessWidget {
  const PaymentPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Amount card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimens.spacingLarge),
          margin: const EdgeInsets.all(Dimens.spacingM),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
          child: Column(
            spacing: Dimens.spacingS,
            children: [
              SkeletonLoader(
                height: 16,
                width: 100,
                borderRadius: BorderRadius.circular(4),
              ),
              SkeletonLoader(
                height: 32,
                width: 150,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacingM),
        // Payment method title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingM),
          child: SkeletonLoader(
            height: 20,
            width: 180,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: Dimens.spacingM),
        // Payment method options
        ...List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingM,
              vertical: Dimens.spacingS,
            ),
            padding: const EdgeInsets.all(Dimens.spacingM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SkeletonLoader(height: 20, width: 20, shape: BoxShape.circle),
                const SizedBox(width: Dimens.spacingM),
                SkeletonLoader(
                  height: 16,
                  width: 120,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
