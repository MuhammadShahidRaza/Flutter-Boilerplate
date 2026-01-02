import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthRepository _authRepository = AuthRepository();
  final RiderRepository _riderRepository = RiderRepository();
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  final phoneController = TextEditingController();
  final emailController = TextEditingController(
    text: kDebugMode ? "harley58@example.com" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "Qwerty@123" : "",
  );
  bool loading = false;
  Future<void> _submit() async {
    setState(() => loading = true);
    final message = await _authRepository.login({
      'phone': phoneController.text.trim(),
    });
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
    setState(() => loading = false);
  }

  Future<void> _submitRider() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() => loading = true);
    final user = await _riderRepository.login({
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      "device_token": token ?? '',
      "udid": token ?? '',
    });
    if (!mounted) return;
    if (user != null) {
      context.read<AuthProvider>().login(context, user);
      AppDialog.show(
        context,
        title: Common.successfullyLoggedIn,
        imagePath: AppAssets.rightTick,
        spacing: Dimens.spacingMSmall,
        dismissible: false,
        content: AppText(
          maxLines: 3,
          textAlign: TextAlign.center,
          Auth.gladToHadYouBack,
        ),
        crossAxisAlignment: CrossAxisAlignment.center,
        insetPadding: EdgeInsets.all(Dimens.spacingXXL),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        context.replacePage(AppRoutes.riderHome);
      });
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isRider = context.read<UserProvider>().isRider;

    return AuthWrapper(
      formKey: _formKey,
      title: Auth.welcomeBackLogin,
      subtitle: Auth.helloAgainLogin,
      isLoading: loading,
      buttonText: Common.signIn,
      onSubmit: isRider ? _submitRider : _submit,
      child: Column(
        spacing: Dimens.spacingS,
        children: [
          if (isRider) ...[
            AppInput(
              title: Common.email,
              hint: Common.enterYourEmail,
              controller: emailController,
              fieldKey: FieldType.email,
            ),
            AppInput(
              title: Common.password,
              hint: Common.enterYourPassword,
              controller: passwordController,
              fieldKey: FieldType.password,
              obscureText: true,
            ),

            // AppCheckbox(
            //   value: rememberMe,
            //   onChanged: (value) {
            //     setState(() {
            //       rememberMe = value;
            //     });
            //   },
            //   label: Common.rememberMe,
            // ),
          ] else ...[
            AppPhoneInput(
              title: Common.phoneNumber,
              hint: Common.enterPhoneNumber,
              controller: phoneController,
              marginBottom: Dimens.spacingM,
            ),
          ],
        ],
      ),
    );
  }
}
