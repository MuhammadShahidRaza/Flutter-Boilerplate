import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController descriptionController;
  bool loading = false;
  late final UserModel? user;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthProvider>();
    user = authUser.user;
    fullNameController = TextEditingController(text: authUser.fullName);
    emailController = TextEditingController(text: user?.email);
    phoneController = TextEditingController(text: user?.phone);
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => loading = true);
    final user = await _authRepository.contactUs(
      email: emailController.text.trim(),
      description: descriptionController.text.trim(),
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    if (!mounted) return;
    if (user != null) {
      context.back();
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      scrollable: true,
      heading: Common.contactUs,
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
                AppText(
                  Common.weAreHereToHelp,
                  style: context.textTheme.bodyMedium,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimens.spacingM),
                AppInput(
                  title: Common.fullName,
                  hint: Common.enterFullName,
                  fieldKey: FieldType.name,
                  enabled: false,
                  controller: fullNameController,
                ),
                AppInput(
                  title: Common.email,
                  enabled: false,
                  hint: Common.enterYourEmail,
                  fieldKey: FieldType.email,
                  controller: emailController,
                ),

                AppPhoneInput(
                  title: Common.phoneNumber,
                  hint: Common.enterPhoneNumber,
                  controller: phoneController,
                  enabled: false,
                  marginBottom: Dimens.spacingM,
                ),

                AppInput(
                  title: Common.description,
                  hint: Common.enterYourMessage,
                  controller: descriptionController,
                  maxLines: 5,
                  minLength: 50,
                  fieldKey: FieldType.required,
                  maxLength: 500,
                  marginBottom: Dimens.spacingM,
                ),

                AppButton(
                  title: Common.submit,
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
