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
  bool loading = false;

  Future<void> _submit() async {
    try {
      setState(() => loading = true);
      final user = await _authRepository.login(
        phone: phoneController.text.trim(),
      );
      if (!mounted) return;

      if (user != null) {
        print(user);
        context.navigate(AppRoutes.verification);
        setState(() => loading = false);
      }
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => loading = false);
      if (error.toString() == "User not found!") {
        context.navigate(AppRoutes.signUp);
      } else if (error.toString() == "Your account is inactive") {
        context.navigate(
          AppRoutes.verification,
          params: {'phone': phoneController.text.trim()},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      formKey: _formKey,
      height: true,
      title: Auth.welcomeBackLogin,
      isLoading: loading,
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
