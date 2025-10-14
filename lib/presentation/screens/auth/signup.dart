import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/utils/index.dart';
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
  // final passwordController = TextEditingController();

  String? selectedGender;

  final genderOptions = ['Male', 'Female', 'Other'];

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      AuthService.saveToken("token");
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
      onSubmit: _submit,
      child: Column(
        spacing: Dimens.spacingXS,
        children: [
          Row(
            spacing: Dimens.spacingM,
            children: [
              Expanded(
                child: AppInput(
                  title: Common.firstName,
                  hint: Common.enterFirstName,
                  fieldKey: FieldType.name,
                  controller: emailController,
                ),
              ),
              Expanded(
                child: AppInput(
                  title: Common.lastName,
                  hint: Common.enterLastName,
                  fieldKey: FieldType.name,
                  controller: emailController,
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
.
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
            controller: emailController,
          ),
        ],
      ),
    );
  }
}
