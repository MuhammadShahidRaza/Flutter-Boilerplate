import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/app.dart';
import 'package:sanam_laundry/providers/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(providers: AppProviders.allProviders, child: const MyApp()),
  );
}
