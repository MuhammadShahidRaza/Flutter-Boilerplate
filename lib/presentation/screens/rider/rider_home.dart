import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/map.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
import 'package:sanam_laundry/presentation/index.dart';

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  // SAMPLE data — replace with provider/api
  final List<String> slots = ['Slot 1', 'Slot 2', 'Slot 3'];
  String selectedSlot = 'Slot 1';
  bool isPickup = true;

  int todayOrders = 12;
  int todayDelivered = 4;
  String onlineTime = '4.2h';

  List<Marker> nearbyMarkers = [];
  // Future<BitmapDescriptor> getPrimaryMarker() async {
  //   return BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(45, 45)),
  //     'assets/icons/marker_primary.png',
  //   );
  // }

  // final primaryIcon = await getPrimaryMarker();

  // Marker(
  //   markerId: MarkerId(e.toString()),
  //   position: e,
  //   icon: primaryIcon,
  // );

  @override
  void initState() {
    super.initState();
    nearbyMarkers =
        [
          const LatLng(37.7750, -122.4193),
          const LatLng(37.7760, -122.4180),
          const LatLng(37.7735, -122.4170),
          const LatLng(37.7720, -122.4200),
        ].map((e) {
          return Marker(
            markerId: MarkerId(e.toString()),
            position: e,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: "ghjas ajks akh k",
            ),
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Small chip button
    Widget statBox(BuildContext c, String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            spacing: Dimens.spacingXS,
            children: [
              AppText(
                value,
                style: context.textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                label,
                style: context.textTheme.labelSmall!.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppWrapper(
      safeArea: false,
      padding: EdgeInsets.zero,
      appBar: HomeAppBar(
        onNotificationTap: () => context.navigate(AppRoutes.notifications),
        iconWidget: Switch(value: true, onChanged: (value) {}),
      ),
      child: AddressPickerMap(
        showCurrentLocationButton: false,
        showMarkerOnTap: false,
        showCurrentLocationMarker: false,
        markers: [...nearbyMarkers],
        // overlay children stacked on top of map
        children: Stack(
          children: [
            // TOP overlay: profile + slot chips + pickup/delivery
            Positioned(
              top: 12,
              left: 5,
              right: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.radiusM,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Slots horizontal chips
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      height: 40,
                      child: AppListView(
                        state: AppListState(
                          items: slots,
                          loadingInitial: false,
                          loadingMore: false,
                          hasMore: false,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, item, index) {
                          final s = slots[index];
                          final selected = s == selectedSlot;
                          return GestureDetector(
                            onTap: () => setState(() => selectedSlot = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: AppText(
                                s,
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Pickup / Delivery toggle chips
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    height: 40,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isPickup = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isPickup
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: AppText(
                              Common.pickUp,
                              style: context.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPickup
                                    ? AppColors.white
                                    : AppColors.text,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isPickup = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: !isPickup
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: AppText(
                              Common.delivery,

                              style: context.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: !isPickup
                                    ? AppColors.white
                                    : AppColors.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BOTTOM overlay: stats row
            Positioned(
              left: 12,
              right: 12,
              bottom: 18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // card style container that looks like screenshot
                  Row(
                    children: [
                      statBox(
                        context,
                        Common.todayOrders,
                        todayOrders.toString().padLeft(2, '0'),
                      ),
                      statBox(
                        context,
                        Common.todayDelivered,
                        todayDelivered.toString().padLeft(2, '0'),
                      ),
                      statBox(context, Common.onlineTime, onlineTime),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
