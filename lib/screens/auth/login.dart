import 'package:flutter/material.dart';
import 'package:sanam_laundry/constants/strings.dart';
import 'package:sanam_laundry/l10n/context_extension.dart';
import 'package:sanam_laundry/routes/app_routes.dart';
import 'package:sanam_laundry/routes/navigator.dart';
import 'package:sanam_laundry/services/auth.dart';
import 'package:sanam_laundry/widgets/button.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Default Flutter ElevatedButton
              ElevatedButton(
                child: Text(context.tr(Common.login)),
                onPressed: () {
                  AuthService.saveToken("token");
                  context.replacePage(AppRoutes.home);
                },
              ),

              const SizedBox(height: 12),

              // Custom Buttons
              AppButton(title: "Login", onPressed: () {}),

              const SizedBox(height: 12),

              AppButton(
                title: "Cancel",
                onPressed: () {},
                type: AppButtonType.outlined,
              ),

              const SizedBox(height: 12),

              AppButton(
                title: "Forgot Password?",
                onPressed: () {},
                type: AppButtonType.text,
              ),

              const SizedBox(height: 12),

              AppButton(title: "Loading...", onPressed: () {}, isLoading: true),
            ],
          ),
        ),
      ),
    );
  }
}
