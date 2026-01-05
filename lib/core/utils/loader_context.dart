// lib/core/utils/loader_context.dart
import 'package:flutter/foundation.dart';

class LoaderContext {
  // ValueNotifier so you can observe if you want (not required).
  static final ValueNotifier<String?> _currentKey = ValueNotifier(null);

  // Read current key
  static String? get currentKey => _currentKey.value;

  // Set (or clear) the key
  static void setKey(String? key) => _currentKey.value = key;
}
