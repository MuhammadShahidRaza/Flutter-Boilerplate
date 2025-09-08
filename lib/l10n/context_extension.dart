import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension TranslateX on BuildContext {
  String tr(String key, {Map<String, String>? params}) {
    return AppLocalizations.of(this)!.translate(key, params: params);
  }
}

// Text(
//   context.tr("GREETING", params: {"name": "Shahid"}),
// ),
