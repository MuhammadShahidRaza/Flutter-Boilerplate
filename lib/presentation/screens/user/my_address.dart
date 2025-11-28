import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/autocomplete.dart';
import 'package:sanam_laundry/core/widgets/map.dart';
import 'package:sanam_laundry/core/widgets/radio_button.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  bool isEditing = false;
  int selectedAddress = -1;
  final _formKey = GlobalKey<FormState>();
  bool get isNewAddress => selectedAddress == -1;
  double? selectedLatitude;
  double? selectedLongitude;

  String? selectedBuildingImage;
  String? selectedApartmentImage;
  XFile? _buildingImage;
  XFile? _apartmentImage;
  bool loading = false;
  final TextEditingController addressTitleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController aptFloorController = TextEditingController();
  final TextEditingController landFullAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prime provider caches once per session
    final prov = context.read<ServicesProvider>();
    prov.ensureAddresses();
  }

  @override
  void dispose() {
    addressTitleController.dispose();
    cityController.dispose();
    stateController.dispose();
    buildingNameController.dispose();
    aptFloorController.dispose();
    landFullAddressController.dispose();
    super.dispose();
  }

  Future<void> addNewAddress() async {
    if (!(_formKey.isValid) ||
        selectedLatitude == null ||
        selectedLongitude == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    final provider = context.read<ServicesProvider>();
    final response = await provider.addNewAddress({
      "label": addressTitleController.text,
      "address": landFullAddressController.text,
      "city": cityController.text,
      "state": stateController.text,
      "latitude": selectedLatitude,
      "longitude": selectedLongitude,
      "building_image_url": _buildingImage,
      "apartment_image_url": _apartmentImage,
      "building_name": buildingNameController.text,
      "floor": aptFloorController.text,
      "is_active": "1",
      "is_default": "1",
    });
    if (response != null) {
      setState(() {
        selectedAddress = response.id;
        addressTitleController.clear();
        cityController.clear();
        stateController.clear();
        buildingNameController.clear();
        aptFloorController.clear();
        landFullAddressController.clear();
      });
    }

    if (!mounted) return;
    context.back();
    setState(() {
      loading = false;
    });
  }

  Future<void> updateAddress() async {
    if (!(_formKey.isValid) ||
        selectedLatitude == null ||
        selectedLongitude == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    final provider = context.read<ServicesProvider>();
    final response = await provider.updateAddress({
      "id": selectedAddress.toString(),
      "_method": "PATCH",
      "label": addressTitleController.text,
      "address": landFullAddressController.text,
      "city": cityController.text,
      "state": stateController.text,
      "latitude": selectedLatitude,
      "longitude": selectedLongitude,
      "building_image_url": _buildingImage,
      "apartment_image_url": _apartmentImage,
      "building_name": buildingNameController.text,
      "floor": aptFloorController.text,
      "is_active": "1",
      "is_default": "1",
    });
    if (response != null) {
      setState(() {
        selectedAddress = response.id;
        addressTitleController.clear();
        cityController.clear();
        stateController.clear();
        buildingNameController.clear();
        aptFloorController.clear();
        landFullAddressController.clear();
      });
    }

    if (!mounted) return;
    context.back();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      heading: "My Addresses",
      scrollable: true,
      showBackButton: true,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.07,
                child: AppImage(
                  path: AppAssets.watermark,
                  width: context.screenWidth,
                  height: context.h(0.45),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(
            height: isNewAddress || isEditing ? null : context.h(0.8),
            child: Consumer<ServicesProvider>(
              builder: (context, services, _) {
                final list = services.addresses;
                return Column(
                  spacing: Dimens.spacingMLarge,
                  children: [
                    // ---- Dynamic Address List ----
                    ...list.map(
                      (item) => _buildAddressTile(
                        item: item,
                        canEdit: true,
                        canDelete: true,
                      ),
                    ),

                    // Add New Address
                    if (list.length < 3)
                      _buildAddressTile(
                        item: AddressModel(
                          id: -1,
                          userId: null,
                          label: "Add New Address",
                          address: "",
                          city: "",
                          state: "",
                          latitude: "",
                          longitude: "",
                          isActive: 0,
                          buildingName: "",
                          floor: "",
                          buildingImage: null,
                          apartmentImage: null,
                          isDefault: null,
                          createdAt: null,
                          updatedAt: null,
                        ),
                      ),

                    if ((isNewAddress && list.length < 3) || isEditing) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ImagePickerBox(
                              initialImagePath:
                                  selectedBuildingImage ??
                                  AppAssets.pickerPlaceholder,
                              borderColor: AppColors.border,
                              wantBottomSpace: false,
                              onImagePicked: (file) {
                                setState(() => _buildingImage = file);
                              },
                              title: "Building Picture",
                            ),
                          ),
                          Expanded(
                            child: ImagePickerBox(
                              initialImagePath:
                                  selectedApartmentImage ??
                                  AppAssets.pickerPlaceholder,
                              borderColor: AppColors.border,
                              wantBottomSpace: false,
                              onImagePicked: (file) {
                                setState(() => _apartmentImage = file);
                              },
                              title: "Apartment Picture",
                            ),
                          ),
                        ],
                      ),
                      AppText(
                        "Upload building image and image of the apartment or door",
                        maxLines: 3,
                        color: AppColors.border,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: context.h(0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: AddressPickerMap(
                            selectedLatLng:
                                (selectedLatitude != null &&
                                    selectedLongitude != null)
                                ? LatLng(selectedLatitude!, selectedLongitude!)
                                : null,
                            onAddressSelected:
                                ({
                                  required String fullAddress,
                                  required String city,
                                  required String state,
                                  required double lat,
                                  required double lng,
                                }) {
                                  // If you want map taps to populate fields, uncomment:
                                  // setState(() {
                                  //   landFullAddressController.text = fullAddress;
                                  //   cityController.text = city;
                                  //   stateController.text = state;
                                  //   selectedLatitude = lat;
                                  //   selectedLongitude = lng;
                                  // });
                                },
                          ),
                        ),
                      ),

                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: Dimens.spacingMSmall,
                          children: [
                            AppAutocomplete(
                              title: "Add Full Address",
                              textEditingController: landFullAddressController,
                              hint: "Street, Area, Landmark",

                              getPlaceDetailWithLatLng: (prediction) {
                                setState(() {
                                  landFullAddressController.text =
                                      prediction.description ?? "";
                                  selectedLatitude = double.tryParse(
                                    prediction.lat ?? "",
                                  );
                                  selectedLongitude = double.tryParse(
                                    prediction.lng ?? "",
                                  );
                                  cityController.text = _extractCity(
                                    prediction.description ?? "",
                                  );
                                  stateController.text = _extractState(
                                    prediction.description ?? "",
                                  );
                                });
                              },
                              itemClick: (prediction) {
                                landFullAddressController.text =
                                    prediction.description!;
                                landFullAddressController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: prediction.description!.length,
                                      ),
                                    );
                              },
                            ),

                            AppInput(
                              fieldKey: FieldType.required,
                              title: "City",
                              enabled: false,
                              controller: cityController,
                              hint: "Jeddah, Riyadh",
                            ),

                            // Row(
                            //   spacing: Dimens.spacingM,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Expanded(
                            //       child: AppInput(
                            //         // fieldKey: FieldType.required,
                            //         title: "City",
                            //         enabled: false,
                            //         controller: cityController,
                            //         hint: "Jeddah, Riyadh",
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: AppInput(
                            //         // fieldKey: FieldType.required,
                            //         title: "State",
                            //         hint: "Makkah, Riyadh",
                            //         enabled: false,
                            //         controller: stateController,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            AppInput(
                              fieldKey: FieldType.required,
                              title: "Address Title",
                              minLength: 3,
                              maxLength: 25,
                              hint: "E.g. Home, Office",
                              controller: addressTitleController,
                            ),
                            Row(
                              spacing: Dimens.spacingM,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppInput(
                                    fieldKey: FieldType.required,
                                    title: "Building Name",
                                    hint: "Tower A, Building 5",
                                    minLength: 3,
                                    maxLength: 25,
                                    controller: buildingNameController,
                                  ),
                                ),
                                Expanded(
                                  child: AppInput(
                                    fieldKey: FieldType.required,
                                    title: "Apt / Floor",
                                    hint: "3rd Floor, Apt 12",
                                    minLength: 3,
                                    maxLength: 25,
                                    controller: aptFloorController,
                                  ),
                                ),
                              ],
                            ),

                            AppButton(
                              isLoading: loading,
                              title: Common.save,
                              onPressed: () {
                                if (isEditing) {
                                  updateAddress();
                                  setState(() {
                                    isEditing = false;
                                  });

                                  return;
                                }
                                if (isNewAddress) {
                                  addNewAddress();
                                } else {
                                  context.back();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile({
    required AddressModel item,
    bool canEdit = false,
    bool canDelete = false,
  }) {
    return AppRadioItem<int>(
      value: item.id,
      label: item.label ?? "",
      groupValue: selectedAddress,
      labelStyle: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      description: item.address,
      onChanged: (val) {
        setState(() => selectedAddress = item.id);
      },
      iconWidget: Row(
        spacing: Dimens.spacingS,
        children: [
          if (canEdit)
            AppIcon(
              icon: Icons.edit_outlined,
              onTap: () async {
                setState(() {
                  isEditing = true;
                  selectedAddress = item.id;
                  landFullAddressController.text = item.address ?? "";
                  cityController.text = item.city ?? "";
                  stateController.text = item.state ?? "";
                  addressTitleController.text = item.label ?? "";
                  buildingNameController.text = item.buildingName ?? "";
                  aptFloorController.text = item.floor ?? "";
                  selectedLatitude = double.tryParse(item.latitude ?? "");
                  selectedLongitude = double.tryParse(item.longitude ?? "");
                  selectedApartmentImage = item.apartmentImage;
                  selectedBuildingImage = item.buildingImage;
                });
              },
              color: AppColors.secondary,
            ),
          if (canDelete)
            AppIcon(
              icon: Icons.delete_outline,
              onTap: () async {
                setState(() {
                  isEditing = false;
                });
                final provider = context.read<ServicesProvider>();
                await provider.deleteAddress(item.id);
                setState(() {
                  if (selectedAddress == item.id) {
                    final remaining = provider.addresses;
                    selectedAddress = remaining.isNotEmpty
                        ? remaining.first.id
                        : -1;
                  }
                });
              },
              color: AppColors.secondary,
            ),
        ],
      ),
    );
  }
}

// String _extractCity(String address) {
//   final parts = address.split(",");
//   return parts.length >= 2 ? parts[parts.length - 2].trim() : "";
// }

// String _extractState(String address) {
//   final parts = address.split(",");
//   return parts.isNotEmpty ? parts.last.trim() : "";
// }

String _extractCity(String address) {
  if (address.trim().isEmpty) return "";

  final parts = address
      .split(',')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  if (parts.isEmpty) return "";

  final last = parts.last;
  final tokens = last.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

  if (tokens.length >= 2) {
    // e.g. "Makkah Saudi Arabia" -> city = "Makkah"
    return tokens.first;
  }

  // last part single word -> try second last as city
  if (parts.length >= 2) {
    return parts[parts.length - 2];
  }

  // fallback: use last
  return last;
}

String _extractState(String address) {
  if (address.trim().isEmpty) return "";

  final parts = address
      .split(',')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  if (parts.isEmpty) return "";

  final last = parts.last;
  final tokens = last.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

  if (tokens.length >= 2) {
    // e.g. ["Makkah","Saudi","Arabia"] -> state = "Saudi Arabia"
    return tokens.sublist(1).join(' ');
  }

  // if last is single word, maybe state is last
  return last;
}
