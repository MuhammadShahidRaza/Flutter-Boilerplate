import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/radio_button.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  int selectedAddress = 0;

  bool get isNewAddress => selectedAddress == -1;
  @override
  Widget build(BuildContext context) {
    final TextEditingController addressTitleController =
        TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController buildingNameController =
        TextEditingController();
    final TextEditingController aptFloorController = TextEditingController();
    final TextEditingController landFullAddressController =
        TextEditingController();

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
                _buildAddressTile(
                  id: 0,
                  title: "My Office Address",
                  subtitle: "Al Qusais - 1, Dubai - UAE",
                  canEdit: true,
                  canDelete: true,
                ),
                _buildAddressTile(
                  id: 1,
                  title: "Home Address",
                  subtitle: "Bur Dubai, Al Fahidi Metro, UAE,Bur Dubai,",
                  canEdit: true,
                  canDelete: true,
                ),

                // Add New Address
                _buildAddressTile(id: -1, title: "Add New Address"),

                if (isNewAddress) ...[
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

                  Row(
                    children: const [
                      Expanded(child: _ImagePreview(title: "Building Picture")),
                      SizedBox(width: 10),
                      Expanded(
                        child: _ImagePreview(title: "Apartment Picture"),
                      ),
                    ],
                  ),

                  // _MapPreview(),
                  Column(
                    spacing: Dimens.spacingMSmall,
                    children: [
                      AppInput(
                        title: "Address Title",
                        hint: "E.g. Home, Office",
                        controller: addressTitleController,
                      ),
                      Row(
                        spacing: Dimens.spacingM,
                        children: [
                          Expanded(
                            child: AppInput(
                              title: "City",
                              controller: cityController,
                              hint: "Jeddah, Riyadh",
                            ),
                          ),
                          Expanded(
                            child: AppInput(
                              title: "State",
                              hint: "Makkah, Riyadh",
                              controller: stateController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: Dimens.spacingM,
                        children: [
                          Expanded(
                            child: AppInput(
                              title: "Building Name",
                              hint: "Tower A, Building 5",
                              controller: buildingNameController,
                            ),
                          ),
                          Expanded(
                            child: AppInput(
                              title: "Apt / Floor",
                              hint: "3rd Floor, Apt 12",
                              controller: aptFloorController,
                            ),
                          ),
                        ],
                      ),
                      AppInput(
                        title: "Add Full Address",
                        hint: "Street, Landmark, Area",
                        controller: landFullAddressController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
                Padding(
                  padding: EdgeInsets.only(top: isNewAddress ? 0 : 100),
                  child: AppButton(
                    title: Common.save,

                    onPressed: () {
                      context.back();
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

class _ImagePreview extends StatelessWidget {
  final String title;
  const _ImagePreview({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            image: const DecorationImage(
              image: AssetImage("assets/temp.jpg"), // your image
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

// class _MapPreview extends StatelessWidget {
//   const _MapPreview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 170,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         image: const DecorationImage(
//           image: AssetImage("assets/map.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
