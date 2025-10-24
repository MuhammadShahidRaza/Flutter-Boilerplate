import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

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

  final genderOptions = [Common.male, Common.female, Common.other];
  late final UserModel? user;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthProvider>().user;
    user = authUser;
    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    selectedGender = genderOptions.firstWhere(
      (g) => g.toLowerCase() == (user?.gender ?? '').toLowerCase(),
    );
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
    setState(() => loading = true);
    final user = await _authRepository.editProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      gender: selectedGender,
      profileImage: _profileImage!,
    );
    if (!mounted) return;
    if (user != null) {
      context.read<AuthProvider>().updateUser(user);
      context.back();
    }
    setState(() => loading = false);
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
                  enabled: false,
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
                  enabled: false,
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
