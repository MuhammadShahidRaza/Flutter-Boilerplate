import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressPickerMap extends StatefulWidget {
  final Function({
    required String fullAddress,
    required String city,
    required String state,
    required double lat,
    required double lng,
  })
  onAddressSelected;

  const AddressPickerMap({super.key, required this.onAddressSelected});

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? marker;

  LatLng _initialLatLng = const LatLng(23.8859, 45.0792);

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  /// Step 1: Get user current location
  Future<void> _setCurrentLocation() async {
    bool permission = await _checkPermission();
    if (!permission) return;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _initialLatLng = LatLng(pos.latitude, pos.longitude);

    _moveCamera(_initialLatLng);

    setState(() {
      marker = Marker(
        markerId: const MarkerId("selected"),
        position: _initialLatLng,
      );
    });

    _reverseGeocode(_initialLatLng);
  }

  /// Step 2: Animate camera
  Future<void> _moveCamera(LatLng target) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
    );
  }

  /// Step 3: Reverse geocode → convert lat/lng → address
  Future<void> _reverseGeocode(LatLng pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isEmpty) return;

      final p = placemarks.first;

      widget.onAddressSelected(
        fullAddress: formatAddress(p),
        city: p.locality ?? "",
        state: p.administrativeArea ?? "",
        lat: pos.latitude,
        lng: pos.longitude,
      );
    } catch (_) {}
  }

  /// Step 4: When user taps map
  Future<void> _handleTap(LatLng pos) async {
    setState(() {
      marker = Marker(markerId: const MarkerId("selected"), position: pos);
    });
    _reverseGeocode(pos);
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
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _initialLatLng, zoom: 12),
      onMapCreated: (controller) => _controller.complete(controller),
      markers: marker != null ? {marker!} : {},
      onTap: _handleTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
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
