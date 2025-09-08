import 'package:flutter/material.dart';
import 'package:sanam_laundry/app.dart';
import 'package:sanam_laundry/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.loadToken();
  runApp(MyApp());
}
