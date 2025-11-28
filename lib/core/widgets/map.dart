import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/icon.dart';

class AddressPickerMap extends StatefulWidget {
  /// When an address is selected externally (e.g., via Autocomplete),
  /// provide the coordinates here to move the camera and update the marker.
  final LatLng? selectedLatLng;
  final Function({
    required String fullAddress,
    required String city,
    required String state,
    required double lat,
    required double lng,
  })
  onAddressSelected;

  const AddressPickerMap({
    super.key,
    required this.onAddressSelected,
    this.selectedLatLng,
  });

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? marker;

  LatLng _initialLatLng = const LatLng(23.8859, 45.0792);
  LatLng? _lastAppliedExternalSelection;

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  @override
  void didUpdateWidget(covariant AddressPickerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If an external selectedLatLng is provided and changed, update the map.
    final ext = widget.selectedLatLng;
    if (ext != null && ext != _lastAppliedExternalSelection) {
      _applyExternalSelection(ext);
    }
  }

  Future<void> _applyExternalSelection(LatLng pos) async {
    _lastAppliedExternalSelection = pos;
    setState(() {
      marker = Marker(markerId: const MarkerId("selected"), position: pos);
    });
    await _moveCamera(pos);
  }

  /// Step 1: Get user current location
  Future<void> _setCurrentLocation({bool showToast = false}) async {
    bool permission = await _checkPermission();
    if (!permission) {
      if (showToast) {
        AppToast.showToast(
          "Location permission is required to pick an address.",
        );
      }
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();

    _initialLatLng = LatLng(pos.latitude, pos.longitude);

    _moveCamera(_initialLatLng);

    setState(() {
      marker = Marker(
        markerId: const MarkerId("selected"),
        position: _initialLatLng,
      );
    });

    // _reverseGeocode(_initialLatLng);
  }

  /// Step 2: Animate camera
  Future<void> _moveCamera(LatLng target) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
    );
  }

  /// Step 3: Reverse geocode → convert lat/lng → address
  // Future<void> _reverseGeocode(LatLng pos) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       pos.latitude,
  //       pos.longitude,
  //     );

  //     if (placemarks.isEmpty) return;

  //     final p = placemarks.first;

  //     widget.onAddressSelected(
  //       fullAddress: formatAddress(p),
  //       city: p.locality ?? "",
  //       state: p.administrativeArea ?? "",
  //       lat: pos.latitude,
  //       lng: pos.longitude,
  //     );
  //   } catch (_) {}
  // }

  /// Step 4: When user taps map
  Future<void> _handleTap(LatLng pos) async {
    setState(() {
      marker = Marker(markerId: const MarkerId("selected"), position: pos);
    });
    // _reverseGeocode(pos);
  }

  /// Permission check
  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialLatLng,
            zoom: 12,
          ),
          onMapCreated: (controller) => _controller.complete(controller),
          markers: marker != null ? {marker!} : {},
          onTap: _handleTap,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
        ),

        Positioned(
          bottom: 20,
          right: 10,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            child: AppIcon(icon: Icons.my_location, color: Colors.blue),
            onPressed: () => _setCurrentLocation(showToast: true),
          ),
        ),
      ],
    );
  }
}

/// Format address
String formatAddress(Placemark p) {
  return [
    p.street,
    p.locality,
    p.subAdministrativeArea,
    p.administrativeArea,
    p.country,
  ].where((e) => e != null && e.isNotEmpty).join(", ");
}
