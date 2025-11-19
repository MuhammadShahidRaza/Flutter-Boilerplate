import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sanam_laundry/providers/index.dart';

class AppProviders {
  static List<SingleChildWidget> allProviders = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => LoaderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => AppProvider()),
    ChangeNotifierProvider(create: (_) => ServicesProvider()),
    // ChangeNotifierProvider(create: (_) => AnotherProvider()),
  ];
}
