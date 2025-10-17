import 'package:flutter/widgets.dart';
import '../../localization/app_localizations.dart';

extension TranslateX on BuildContext {
  String tr(String key, {Map<String, String>? params}) {
    return AppLocalizations.of(this)!.translate(key, params: params);
  }
}
