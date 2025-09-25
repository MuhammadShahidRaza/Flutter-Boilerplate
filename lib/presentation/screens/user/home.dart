import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/constants/strings.dart';
import 'package:sanam_laundry/core/extensions/localization.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/core/extensions/navigator.dart';
import 'package:sanam_laundry/data/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: ElevatedButton(
          child: Text(context.tr(Common.logout)),
          onPressed: () {
            AuthService.removeToken();
            context.replacePage(AppRoutes.login);
          },
        ),
      ),
    );
  }
}
