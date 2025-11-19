import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  Future<void> _submit() async {
    final message = await _authRepository.login(
      phone: phoneController.text.trim(),
    );
    if (!mounted) return;
    if (message != null) {
      if (message == "loginSuccessful") {
        context.navigate(
          AppRoutes.verification,
          params: {'phone': phoneController.text.trim(), 'isFromLogin': true},
        );
      } else if (message == "userNotFound") {
        context.navigate(
          AppRoutes.signUp,
          params: {'phone': phoneController.text.trim()},
        );
      } else if (message == "userNotVerified") {
        context.navigate(
          AppRoutes.verification,
          params: {'phone': phoneController.text.trim(), 'isFromLogin': true},
        );
      } else {
        AppToast.showToast(message, isError: true);
      }
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
            hint: Common.enterPhoneNumber,
            controller: phoneController,
            marginBottom: Dimens.spacingM,
          ),
        ],
      ),
    );
  }
}
