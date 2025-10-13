import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/data/services/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';
import 'package:sanam_laundry/presentation/screens/auth/auth_wrapper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      title: Auth.welcomeBackLogin,
      subtitle: Auth.helloAgainLogin,
      buttonText: Common.signIn,
      onSubmit: _submit,
      child: Column(
        children: [
          AppInput(
            label: Common.email,
            hint: Common.enterYourEmail,
            fieldKey: FieldType.email,
            controller: emailController,
          ),
          AppInput(
            title: Common.password,
            hint: Common.enterYourPassword,
            fieldKey: FieldType.password,
            controller: passwordController,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
