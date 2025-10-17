import 'package:flutter/material.dart';
import 'package:sanam_laundry/localization/index.dart';
import 'package:sanam_laundry/core/routes/router.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouterSetup.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: const Locale('en'),
      supportedLocales: AppLocalizationSetup.supportedLocales,
      localizationsDelegates: AppLocalizationSetup.localizationsDelegates,
      localeResolutionCallback: AppLocalizationSetup.resolveLocale,
      // builder: (context, child) {
      //   return SafeArea(bottom: false, child: child!); // 👈 Global SafeArea
      // },
    );
  }
}
