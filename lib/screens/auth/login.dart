import 'package:flutter/material.dart';
import 'package:sanam_laundry/constants/strings.dart';
import 'package:sanam_laundry/routes/app_routes.dart';
import 'package:sanam_laundry/routes/navigator.dart';
import 'package:sanam_laundry/services/auth.dart';
import 'package:sanam_laundry/widgets/button.dart';
import 'package:sanam_laundry/widgets/input.dart';

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
      // ✅ Form is valid → proceed with login
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");

      AuthService.saveToken("token");
      context.replacePage(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppInput(
                label: Common.email,
                hint: Common.enterYourEmail,
                fieldKey: FieldType.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              AppInput(
                label: Common.password,
                hint: Common.enterYourPassword,
                fieldKey: FieldType.password,
                controller: passwordController,
                obscureText: true,
              ),

              AppButton(title: Common.login, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
