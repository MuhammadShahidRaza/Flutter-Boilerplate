import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/index.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/core/widgets/phone_input.dart';
import 'package:sanam_laundry/data/services/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/auth/auth_wrapper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

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
      height: true,
      title: Auth.welcomeBackLogin,
      subtitle: Auth.helloAgainLogin,
      buttonText: Common.signIn,
      onSubmit: _submit,
      child: Column(
        children: [
          AppPhoneInput(
            title: Common.phoneNumber,
            hint: Common.enterYourPhoneNumber,
            controller: phoneController,
            marginBottom: Dimens.spacingM,
          ),
        ],
      ),
    );
  }
}
