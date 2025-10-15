import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/checkbox.dart';
import 'package:sanam_laundry/core/widgets/image_picker.dart';
import 'package:sanam_laundry/core/widgets/phone_input.dart';
import 'package:sanam_laundry/data/services/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/auth/auth_wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedGender;
  bool _agreedTerms = false;

  final genderOptions = [Common.male, Common.female, Common.other];

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      AuthService.saveToken(Variables.userToken);
      context.replacePage(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      formKey: _formKey,
      title: Common.createAnAccount,
      subtitle: Auth.connectWithSignup,
      buttonText: Common.signUp,
      bottomText: Common.alreadyHaveAnAccount,
      bottomButtonText: Common.signIn,
      bottomButtonPress: () {
        context.replacePage(AppRoutes.login);
      },
      onSubmit: _submit,
      child: Column(
        spacing: Dimens.spacingXS,
        children: [
          ImagePickerBox(),
          Row(
            spacing: Dimens.spacingM,
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

          AppCheckbox(
            value: _agreedTerms,
            onChanged: (bool val) => setState(() => _agreedTerms = val),
            label: Common.termOfUseAndPrivacy,
          ),
        ],
      ),
    );
  }
}
