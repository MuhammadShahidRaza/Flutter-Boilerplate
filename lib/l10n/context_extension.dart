import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension TranslateX on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)!.translate(key);
  }
}

// Text(context.tr("hello"))
