import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/core/utils/launcher.dart';
import 'package:sanam_laundry/core/widgets/map.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/rider_repositories/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class RiderHomeOrder extends StatefulWidget {
  const RiderHomeOrder({super.key});

  @override
  State<RiderHomeOrder> createState() => _RiderHomeOrderState();
}

class _RiderHomeOrderState extends State<RiderHomeOrder> {
  final RiderRepository _riderRepository = RiderRepository();
  bool _updatingStatus = false;

  bool showOrders = false;
  final ScrollController mapScrollController = ScrollController();

  bool isPickup = true;
  bool _initialized = false;

  OrderModel? orderDetails;
  late final PolylinePoints _polylinePoints;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  VoidCallback? onOrderUpdated;

  LatLng? user;

  LatLng get pickupLatLng => LatLng(user?.latitude ?? 0, user?.longitude ?? 0);

  LatLng get dropLatLng => LatLng(
    double.parse(orderDetails?.latitude ?? '0'),
    double.parse(orderDetails?.longitude ?? '0'),
  );

  Future<void> _drawRoute() async {
    if (orderDetails == null) return;

    final result = await _polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isEmpty) {
      debugPrint('MAP: No route points received');
      return;
    }

    final routePoints = result.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('order_route'),
          color: AppColors.primary,
          width: 5,
          points: routePoints,
        ),
      };

      _markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Pickup Location',
            snippet: "Sanam Driver",
          ),
        ),
        Marker(
          markerId: MarkerId('drop'),
          position: dropLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Drop-off Location',
            snippet: Utils.getfullName(orderDetails!.user),
          ),
        ),
      };
    });
  }

  Future<void> _loadOrderDetailsById() async {
    if (orderDetails?.id == null) return;
    final response = await _riderRepository.getOrderDetailsById(
      orderDetails!.id!.toString(),
    );
    if (response != null) {
      setState(() {
        orderDetails = response;
      });

      _drawRoute(); // 👈 IMPORTANT
    }
  }

  String pickUpLocationAddress = '';

  /// Step 3: Reverse geocode → convert lat/lng → address
  void _reverseGeocode(LatLng pos) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isEmpty) return;

      final p = placemarks.first;

      setState(() {
        pickUpLocationAddress = formatAddress(p);
      });
    } catch (e) {
      debugPrint("Reverse geocode error: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      orderDetails = context.getExtra()?["item"];
      onOrderUpdated = context.getExtra()?["onUpdateStatus"];
      _initialized = true;
      _loadOrderDetailsById();

      final authUser = context.read<UserProvider>();
      _reverseGeocode(authUser.currentLocation);
      user = authUser.currentLocation;
    }
  }

  Future<void> updateRiderActiveStatus(bool value) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.updateRiderActiveStatus(
      location: provider.currentLocation,
      isActive: value,
    );
    await _riderRepository.updateRiderActiveStatus(
      isActive: value,
      location: provider.currentLocation,
    );
  }

  Future<OrderModel?> updateOrderStatus(status) async {
    final response = await _riderRepository.updateOrderStatus(
      status: status,
      id: orderDetails!.id!.toString(),
    );

    if (response != null) {
      setState(() => orderDetails = response);
      return response;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints(apiKey: Environment.mapKey);
  }

  void onPressed(status) async {
    if (context.read<UserProvider>().user?.isRiderActive == false) {
      AppToast.showToast(
        "You are currently inactive. Please go active to proceed.",
      );
      return;
    }
    final updatedOrder = await updateOrderStatus(status);
    if (updatedOrder != null) {
      onOrderUpdated?.call();
    }
    if (!mounted) return;
    context.back();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = context.watch<UserProvider>().user?.isRiderActive ?? false;
    final hasTwoButtons = orderDetails?.nextStatus == "Arrived For Pick-up";
    final height = context.h(hasTwoButtons ? 0.55 : 0.47);
    return AppWrapper(
      safeArea: Platform.isAndroid ? true : false,
      padding: EdgeInsets.zero,
      appBar: HomeAppBar(
        onNotificationTap: () => context.navigate(AppRoutes.riderNotifications),
        containerGap: Dimens.spacingXS,
        iconWidget: Row(
          children: [
            if (isActive)
              AppText(
                Common.active,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            Switch(
              value: isActive,

              onChanged: _updatingStatus
                  ? null
                  : (value) async {
                      setState(() => _updatingStatus = true);
                      await updateRiderActiveStatus(value);
                      if (mounted) {
                        setState(() => _updatingStatus = false);
                      }
                    },
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
        showMapCurrentLocationMarker: false,
        polylines: _polylines,
        bottomHeight: height,
        markers: _markers.toList(),
        // overlay children stacked on top of map
        children: Stack(
          children: [
            // BOTTOM overlay: stats row
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 80,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  spacing: Dimens.spacingLarge,
                  children: [
                    Row(
                      spacing: Dimens.spacingMLarge,
                      children: [
                        // 👤 User avatar
                        AppImage(
                          path:
                              orderDetails?.user?.profileImage ??
                              AppAssets.user,
                          width: 50,
                          height: 50,
                        ),

                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: AppText(
                              Utils.getfullName(orderDetails?.user),
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // 🔔 Notification icon
                        AppIcon(
                          icon: Icons.call_outlined,
                          borderWidth: 1,
                          color: AppColors.white,
                          onTap: () {
                            AppLauncher.openPhone(
                              orderDetails?.user?.phone ?? '',
                            );
                          },
                          padding: EdgeInsets.all(8),
                          backgroundColor: AppColors.primary,
                          borderColor: AppColors.primary,
                        ),
                      ],
                    ),

                    Expanded(
                      child: MessageBox(
                        icon: Icons.numbers,
                        title: Common.orderId,
                        value: orderDetails?.orderNumber ?? 'N/A',
                        descriptionMaxLines: 3,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pickUpLocationAddress.isNotEmpty)
                          Expanded(
                            child: MessageBox(
                              onTap: () {
                                if (user?.latitude != null &&
                                    user?.longitude != null) {
                                  AppLauncher.openLink(
                                    'https://www.google.com/maps/search/?api=1&query=${user?.latitude},${user?.longitude}',
                                  );
                                }
                              },
                              icon: Icons.location_on_outlined,
                              title: Common.pickUpLocation,
                              value: pickUpLocationAddress,
                              descriptionMaxLines: 3,
                            ),
                          ),
                        Expanded(
                          child: MessageBox(
                            onTap: () {
                              AppLauncher.openLink(
                                'https://www.google.com/maps/search/?api=1&query=${orderDetails?.latitude},${orderDetails?.longitude}',
                              );
                            },
                            icon: Icons.location_on_outlined,
                            title: Common.destination,
                            value: orderDetails?.address ?? 'N/A',
                            descriptionMaxLines: 3,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: Dimens.spacingM,
                      children: [
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
                                context.pop(),
                                onPressed(orderDetails?.nextStatus),
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

                        if (orderDetails?.nextStatus == "Arrived For Pick-up")
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
                                  context.pop(),
                                  onPressed("Unsuccessful Attempt"),
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
                            backgroundColor: AppColors.bottomTabText,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: hasTwoButtons ? context.h(0.42) : context.h(0.35),
              left: context.w(0.25),

              child: AppImage(
                path: AppAssets.orderModalLocation,
                width: 200,
                height: 200,
                isCircular: true,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
