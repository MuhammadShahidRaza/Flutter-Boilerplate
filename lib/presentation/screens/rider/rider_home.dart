import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/core/widgets/map.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/data/rider_repositories/index.dart';
import 'package:sanam_laundry/presentation/components/job_card.dart';
import 'package:sanam_laundry/presentation/index.dart';

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final RiderRepository _riderRepository = RiderRepository();

  bool showOrders = false;
  final ScrollController mapScrollController = ScrollController();

  // SAMPLE data — replace with provider/api
  final List<SlotModel> slots = [];
  String selectedSlotId = '1';
  bool isPickup = true;

  int todayOrders = 0;
  int todayDelivered = 0;
  String onlineTime = "0h";

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

  List<OrderModel> orders = [];

  Future<void> _loadOrders() async {
    setState(() {
      orders = [];
      nearbyMarkers = [];
    });

    final data = await _riderRepository.getHomeOrders(
      type: isPickup ? "pickup" : "delivery",
      slotId: selectedSlotId,
    );
    if (!mounted) return;
    if (data == null) return;
    setState(() {
      nearbyMarkers = data["orders"].isEmpty
          ? <Marker>[]
          : data["orders"].map<Marker>((e) {
              return Marker(
                markerId: MarkerId(e.toString()),
                position: LatLng(
                  double.tryParse(e.latitude.toString()) ?? 0.0,
                  double.tryParse(e.longitude.toString()) ?? 0.0,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  isPickup
                      ? BitmapDescriptor.hueAzure
                      : BitmapDescriptor.hueRed,
                ),
                infoWindow: InfoWindow(
                  onTap: () {
                    context.navigate(
                      AppRoutes.jobDetails,
                      extra: e.id.toString(),
                    );
                  },
                  title: Utils.getfullName(e.user),
                  snippet: "${context.tr(Common.orderId)} ${e.id}",
                ),
              );
            }).toList();
      showOrders = true;
      orders = data["orders"] ?? [];
      todayOrders = data["info"]?['today_orders_count'] ?? 0;
      todayDelivered = data["info"]?['total_delivery_count'] ?? 0;
      onlineTime = "${data["info"]?['today_online_time'] ?? "0"}h";
    });
  }

  Future<void> slotsFuture() async {
    await _riderRepository.getSlots().then((value) {
      if (!mounted) return;
      setState(() {
        slots.clear();
        slots.addAll(value ?? []);
        if (slots.isNotEmpty) {
          selectedSlotId = slots.first.id;
        }
      });
      _loadOrders();
    });
  }

  @override
  void initState() {
    super.initState();
    slotsFuture();
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
        containerGap: Dimens.spacingXS,
        iconWidget: Row(
          children: [
            AppText(
              "Active",
              style: context.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: true,
              onChanged: (value) {},
              thumbColor: WidgetStatePropertyAll(AppColors.secondary),
              activeThumbColor: AppColors.tertiary,
              trackOutlineColor: WidgetStatePropertyAll(AppColors.primary),
              trackOutlineWidth: WidgetStatePropertyAll(1),
            ),
          ],
        ),
      ),
      child: AddressPickerMap(
        showMarkerOnTap: false,
        showCurrentLocationMarker: false,
        showMapCurrentLocationMarker: true,
        bottomHeight: 90,
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
                  if (slots.isNotEmpty)
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
                            final selected = s.id == selectedSlotId;
                            return GestureDetector(
                              onTap: () {
                                if (selectedSlotId == s.id) return;
                                setState(() => selectedSlotId = s.id);
                                _loadOrders();
                              },
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
                                  s.title ?? "",
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
                          onTap: () {
                            if (isPickup) return;
                            setState(() => isPickup = true);
                            _loadOrders();
                          },
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
                          onTap: () {
                            if (!isPickup) return;
                            setState(() => isPickup = false);
                            _loadOrders();
                          },
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

            if (orders.isNotEmpty && showOrders) ...[
              Positioned(
                bottom: 140,
                left: 15,
                right: 15,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 250),
                  opacity: showOrders ? 1 : 0,
                  child: Visibility(
                    visible: showOrders,
                    child: AppListView(
                      state: AppListState(
                        items: orders.take(2).toList(),
                        loadingInitial: false,
                        loadingMore: false,
                        hasMore: false,
                      ),
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, item, index) {
                        return JobCard(
                          order: item,
                          type: isPickup ? "pickup" : "delivery",
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],

            if (orders.isNotEmpty)
              Positioned(
                bottom: 90,
                left: 12,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  child: AppIcon(
                    icon: showOrders
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.blue,
                  ),
                  onPressed: () => setState(() => showOrders = !showOrders),
                ),
              ),

            // BOTTOM overlay: stats row
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // card style container that looks like screenshot
                  Row(
                    children: [
                      statBox(
                        context,
                        Common.todayOrders,
                        todayOrders.toString(),
                      ),
                      statBox(
                        context,
                        Common.todayDelivered,
                        todayDelivered.toString(),
                      ),
                      statBox(
                        context,
                        Common.onlineTime,
                        onlineTime.toString(),
                      ),
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
