import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'auth.dart';

class AppProviders {
  static List<SingleChildWidget> allProviders = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    // ChangeNotifierProvider(create: (_) => AnotherProvider()),
  ];
}
