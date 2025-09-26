import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/app.dart';
import 'package:sanam_laundry/core/config/environment.dart';
import 'package:sanam_laundry/providers/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  GoogleFonts.config.allowRuntimeFetching = false;
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.dark,

  //     statusBarBrightness: Brightness.dark,
  //   ),
  // );

  runApp(
    MultiProvider(providers: AppProviders.allProviders, child: const MyApp()),
  );
}
