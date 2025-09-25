import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/index.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/data/services/index.dart';
import 'package:sanam_laundry/core/widgets/index.dart';
import 'package:sanam_laundry/core/extensions/index.dart';

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
        padding: const EdgeInsets.all(Dimens.screenMargin),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: Dimens.spacingMLarge,
            children: [
              AppImage(
                path: AppAssets.logo,
                isAsset: true,
                width: context.screenWidth,
                height: context.h(0.25),
              ),
              AppText(
                Auth.welcomeBackLogin,
                fontSize: context.textTheme.titleLarge?.fontSize,
              ),
              AppText(
                TemporaryText.lorumIpsum,
                fontSize: context.textTheme.bodySmall?.fontSize,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              // AppInput(
              //   label: Common.email,
              //   hint: Common.enterYourEmail,
              //   fieldKey: FieldType.email,
              //   controller: emailController,
              //   keyboardType: TextInputType.emailAddress,
              // ),
              AppInput(
                label: Common.password,
                hint: Common.enterYourPassword,
                fieldKey: FieldType.password,
                controller: passwordController,
                obscureText: true,
              ),

              AppButton(title: Common.signIn, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
