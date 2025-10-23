import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  XFile? _profileImage;
  bool loading = false;
  String? selectedGender;
  bool _agreedTerms = false;

  final genderOptions = [Common.male, Common.female, Common.other];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      // if (_profileImage == null) {
      //   AppToast.showToast("Please select a profile image.");
      //   return;
      // }

      if (!_agreedTerms) {
        AppToast.showToast("Please agree to the terms and conditions.");
        return;
      }

      setState(() => loading = true);

      // device_type:Testing Tool
      // device_token:abcdefghijklmnopqrstuvwxyz
      // udid:123456789
      // device_brand:Postman
      // device_os:Linux
      // app_version:1.0.0

      final user = await _authRepository.editProfile(
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        gender: selectedGender,
        // profileImage: _profileImage!,
      );
      if (!mounted) return;
      if (user != null) {
        context.navigate(
          AppRoutes.verification,
          params: {'phone': phoneController.text.trim(), "isFromLogin": false},
        );
        // setState(() => loading = false);
      }
    } on Exception catch (error) {
      print(error);
      // setState(() => loading = false);
      // context.navigate(AppRoutes.verification);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: true,
      heading: Common.editProfile,
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

          Form(
            key: _formKey,
            child: Column(
              spacing: Dimens.spacingXS,
              children: [
                ImagePickerBox(
                  onImagePicked: (file) {
                    setState(() => _profileImage = file);
                  },
                ),
                Row(
                  spacing: Dimens.spacingM,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppInput(
                        title: Common.firstName,
                        hint: Common.enterFirstName,
                        fieldKey: FieldType.name,
                        controller: firstNameController,
                      ),
                    ),
                    Expanded(
                      child: AppInput(
                        title: Common.lastName,
                        hint: Common.enterLastName,
                        fieldKey: FieldType.name,
                        controller: lastNameController,
                      ),
                    ),
                  ],
                ),
                AppInput(
                  title: Common.email,
                  hint: Common.enterYourEmail,
                  fieldKey: FieldType.email,
                  controller: emailController,
                ),
                AppDropdown<String>(
                  title: Common.gender,
                  hint: Common.selectGender,
                  items: genderOptions,
                  value: selectedGender,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),

                AppPhoneInput(
                  title: Common.phoneNumber,
                  hint: Common.enterYourPhoneNumber,
                  controller: phoneController,
                  marginBottom: Dimens.spacingM,
                ),

                AppButton(
                  title: Common.save,
                  onPressed: () {
                    if (!(_formKey.isValid)) return;
                    _submit();
                  },
                  isLoading: loading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
