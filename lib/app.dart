import 'package:flutter/material.dart';
import 'package:sanam_laundry/l10n/setup.dart';
import 'package:sanam_laundry/routes/router.dart';
import 'package:sanam_laundry/theme/app_theme.dart';

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
      supportedLocales: AppLocalizationSetup.supportedLocales,
      localizationsDelegates: AppLocalizationSetup.localizationsDelegates,
      localeResolutionCallback: AppLocalizationSetup.resolveLocale,
    );
  }
}
