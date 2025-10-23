import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

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

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
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
                AppInput(
                  title: Common.fullName,
                  hint: Common.enterFullName,
                  fieldKey: FieldType.name,
                  controller: fullNameController,
                ),
                AppInput(
                  title: Common.email,
                  hint: Common.enterYourEmail,
                  fieldKey: FieldType.email,
                  controller: emailController,
                ),

                AppPhoneInput(
                  title: Common.phoneNumber,
                  hint: Common.enterYourPhoneNumber,
                  controller: phoneController,
                  marginBottom: Dimens.spacingM,
                ),

                AppInput(
                  title: Common.description,
                  hint: Common.enterYourMessage,
                  controller: descriptionController,
                  maxLines: 5,
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
