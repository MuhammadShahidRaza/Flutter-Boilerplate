import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/map.dart';
import 'package:sanam_laundry/core/widgets/radio_button.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final HomeRepository _homeRepository = HomeRepository();
  List<AddressModel?> addresseses = [];
  int selectedAddress = -1;
  final _formKey = GlobalKey<FormState>();
  bool get isNewAddress => selectedAddress == -1;
  double? selectedLatitude;
  double? selectedLongitude;

  final TextEditingController addressTitleController = TextEditingController(
    text: "",
  );
  final TextEditingController cityController = TextEditingController(text: "");
  final TextEditingController stateController = TextEditingController(text: "");
  final TextEditingController buildingNameController = TextEditingController(
    text: "",
  );
  final TextEditingController aptFloorController = TextEditingController(
    text: "",
  );
  final TextEditingController landFullAddressController = TextEditingController(
    text: "",
  );

  void loadAddresses() async {
    final data = await _homeRepository.getAddresses();
    setState(() {
      addresseses = data ?? [];
      selectedAddress = addresseses.isNotEmpty ? 0 : -1;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAddresses();
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
    final response = await _homeRepository.addNewAddress({
      "label": addressTitleController.text,
      "address": landFullAddressController.text,
      "city": cityController.text,
      "state": stateController.text,
      "latitude": selectedLatitude,
      "longitude": selectedLongitude,
      "is_default": 1,
      "is_active": 1,
    });

    if (response != null) {
      setState(() {
        addresseses.add(response);
      });
      setState(() {
        selectedAddress = addresseses.length - 1;
        addressTitleController.clear();
        cityController.clear();
        stateController.clear();
        buildingNameController.clear();
        aptFloorController.clear();
        landFullAddressController.clear();
      });
    }
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
            height: isNewAddress ? null : context.h(0.8),
            child: Column(
              spacing: Dimens.spacingMLarge,
              children: [
                // ---- Dynamic Address List ----
                ...addresseses.asMap().entries.map((entry) {
                  int index = entry.key;
                  AddressModel item = entry.value!;

                  return _buildAddressTile(
                    id: index,
                    title: item.label ?? "",
                    subtitle: item.address ?? "",
                    canEdit: true,
                    canDelete: true,
                  );
                }),

                // SizedBox(
                //   height: isNewAddress ? null : context.h(0.8),
                //   child: Column(
                //     spacing: Dimens.spacingMLarge,
                //     children: [

                //       _buildAddressTile(
                //         id: 0,
                //         title: "My Office Address",
                //         subtitle: "Al Qusais - 1, Dubai - UAE",
                //         canEdit: true,
                //         canDelete: true,
                //       ),
                //       _buildAddressTile(
                //         id: 1,
                //         title: "Home Address",
                //         subtitle: "Bur Dubai, Al Fahidi Metro, UAE,Bur Dubai,",
                //         canEdit: true,
                //         canDelete: true,
                //       ),

                // Add New Address
                if (addresseses.length < 3)
                  _buildAddressTile(id: -1, title: "Add New Address"),

                if (isNewAddress && addresseses.length < 3) ...[
                  ImagePickerBox(
                    imageBoxWidth: context.w(0.6),
                    imageBoxHeight: context.h(0.18),
                    initialImagePath: AppAssets.pickerPlaceholder,
                    borderColor: AppColors.border,
                    onImagePicked: (file) {
                      // setState(() => _profileImage = file);
                    },
                    title:
                        "Uploading building images and images of the apartment or door",
                  ),

                  // Row(
                  //   children: const [
                  //     Expanded(child: _ImagePreview(title: "Building Picture")),
                  //     SizedBox(width: 10),
                  //     Expanded(
                  //       child: _ImagePreview(title: "Apartment Picture"),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: context.h(0.3),
                  //   width: context.screenWidth,
                  //   child: MapSample(
                  //     onLocationSelected: (lat, lng) {
                  //       selectedLatitude = lat;
                  //       selectedLongitude = lng;
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: context.h(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AddressPickerMap(
                        onAddressSelected:
                            ({
                              required String fullAddress,
                              required String city,
                              required String state,
                              required double lat,
                              required double lng,
                            }) {
                              setState(() {
                                landFullAddressController.text = fullAddress;
                                cityController.text = city;
                                stateController.text = state;
                                selectedLatitude = lat;
                                selectedLongitude = lng;
                              });
                            },
                      ),
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: Dimens.spacingMSmall,
                      children: [
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
                                title: "City",
                                controller: cityController,
                                hint: "Jeddah, Riyadh",
                              ),
                            ),
                            Expanded(
                              child: AppInput(
                                fieldKey: FieldType.required,
                                title: "State",
                                hint: "Makkah, Riyadh",
                                controller: stateController,
                              ),
                            ),
                          ],
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
                        AppInput(
                          fieldKey: FieldType.required,
                          title: "Add Full Address",
                          hint: "Street, Landmark, Area",
                          controller: landFullAddressController,
                          maxLines: 3,
                          minLength: 10,
                          maxLength: 100,
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.only(top: isNewAddress ? 0 : 100),
                  child: AppButton(
                    title: Common.save,
                    onPressed: () {
                      addNewAddress();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile({
    required int id,
    required String title,
    String subtitle = "",
    bool canEdit = false,
    bool canDelete = false,
  }) {
    return AppRadioItem<int>(
      value: id,
      label: title,
      groupValue: selectedAddress,
      labelStyle: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      description: subtitle,
      onChanged: (val) {
        setState(() => selectedAddress = id);
      },
      iconWidget: Row(
        spacing: Dimens.spacingS,
        children: [
          if (canEdit)
            AppIcon(
              icon: Icons.edit_outlined,
              onTap: () {},
              color: AppColors.secondary,
            ),
          if (canDelete)
            AppIcon(
              icon: Icons.delete_outline,
              onTap: () {},
              color: AppColors.secondary,
            ),
        ],
      ),
    );
  }
}

// class _ImagePreview extends StatelessWidget {
//   final String title;
//   const _ImagePreview({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           height: 110,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade300),
//             image: const DecorationImage(
//               image: AssetImage("assets/temp.jpg"), // your image
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
