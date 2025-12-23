import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/icon.dart';
import 'package:sanam_laundry/providers/index.dart';

class AddressPickerMap extends StatefulWidget {
  /// When an address is selected externally (e.g., via Autocomplete),
  /// provide the coordinates here to move the camera and update the marker.
  final Widget? children;
  final LatLng? selectedLatLng;
  final List<Marker>? markers;

  final Function({
    required String fullAddress,
    required String city,
    required String state,
    required double lat,
    required double lng,
  })?
  onAddressSelected;
  final bool showCurrentLocationButton;
  final bool showCurrentLocationMarker;
  final bool showMarkerOnTap;
  final bool showMapCurrentLocationMarker;
  final double bottomHeight;
  final Set<Polyline>? polylines;

  const AddressPickerMap({
    super.key,
    this.onAddressSelected,
    this.selectedLatLng,
    this.showCurrentLocationButton = true,
    this.showCurrentLocationMarker = true,
    this.polylines,
    this.showMarkerOnTap = true,
    this.showMapCurrentLocationMarker = false,
    this.children,
    this.bottomHeight = 20,
    this.markers,
  });

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? marker;
  final Set<Marker> allMarkers = {};

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
    if (widget.showCurrentLocationMarker) {
      setState(() {
        marker = Marker(
          markerId: const MarkerId("selected"),
          position: _initialLatLng,
        );
      });
    }

    if (mounted) {
      final provider = context.read<UserProvider>();
      provider.updateCurrentLocation(_initialLatLng);
    }
    _reverseGeocode(_initialLatLng);
  }

  /// Step 2: Animate camera
  Future<void> _moveCamera(LatLng target) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
    );
  }

  Timer? _geoDebounce;
  bool _isGeocoding = false;

  String extractCity(Placemark p) {
    return p.locality ?? p.subAdministrativeArea ?? p.administrativeArea ?? "";
  }

  String extractState(Placemark p) {
    return p.administrativeArea ?? p.subAdministrativeArea ?? "";
  }

  /// Step 3: Reverse geocode → convert lat/lng → address
  void _reverseGeocode(LatLng pos) {
    _geoDebounce?.cancel();

    _geoDebounce = Timer(const Duration(milliseconds: 600), () async {
      if (_isGeocoding) return;
      _isGeocoding = true;

      try {
        final placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );

        if (placemarks.isEmpty) return;

        final p = placemarks.first;

        widget.onAddressSelected?.call(
          fullAddress: formatAddress(p),
          city: extractCity(p),
          state: extractState(p),
          lat: pos.latitude,
          lng: pos.longitude,
        );
      } catch (e) {
        debugPrint("Reverse geocode error: $e");
      } finally {
        _isGeocoding = false;
      }
    });
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
    if (widget.markers != null) {
      allMarkers.addAll(widget.markers!);
    }

    if (marker != null) {
      allMarkers.add(marker!);
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialLatLng,
            zoom: 12,
          ),
          polylines: widget.polylines ?? {},
          onMapCreated: (controller) => _controller.complete(controller),
          markers: allMarkers,
          onTap: widget.showMarkerOnTap ? _handleTap : null,
          myLocationEnabled: widget.showMapCurrentLocationMarker,
          myLocationButtonEnabled: false,
        ),

        widget.children ?? const SizedBox.shrink(),

        if (widget.showCurrentLocationButton)
          Positioned(
            bottom: widget.bottomHeight,
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
