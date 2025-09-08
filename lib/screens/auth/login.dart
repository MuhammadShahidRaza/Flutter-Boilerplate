import 'package:flutter/material.dart';
import 'package:sanam_laundry/constants/strings.dart';
import 'package:sanam_laundry/l10n/context_extension.dart';
import 'package:sanam_laundry/routes/app_routes.dart';
import 'package:sanam_laundry/routes/navigator.dart';
import 'package:sanam_laundry/services/auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text(context.tr(Common.login)),
          onPressed: () {
            AuthService.saveToken("token");
            context.replacePage(AppRoutes.home);
          },
        ),
      ),
    );
  }
}
