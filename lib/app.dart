import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/localization/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppProvider>().locale;
    return MaterialApp.router(
      routerConfig: GoRouterSetup.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: AppToast.scaffoldMessengerKey,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizationSetup().supportedLocales,
      localizationsDelegates: AppLocalizationSetup.localizationsDelegates,
      localeResolutionCallback: AppLocalizationSetup.resolveLocale,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return MediaQuery.withNoTextScaling(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return; // inner navigator handled it
              // Delegate to shared handler (auth screens only handled here)
              await AppBackHandler.handleBack(context);
            },
            child: AppLoaderOverlay(child: content),
          ),
        );
      },
    );
  }
}
