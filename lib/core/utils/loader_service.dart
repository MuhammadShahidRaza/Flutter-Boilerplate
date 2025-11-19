import 'package:flutter/foundation.dart';

class LoaderService {
  LoaderService._();
  static final LoaderService instance = LoaderService._();

  /// 🔹 Global counter (for full-screen overlay loader)
  final ValueNotifier<int> globalCounter = ValueNotifier(0);

  /// 🔹 Scoped counters (for per-button loaders)
  final ValueNotifier<Map<String, int>> scopedCounters = ValueNotifier({});

  // ---------------------------------------------------------------------------
  // ✅ Public API
  // ---------------------------------------------------------------------------

  /// Show a global (full-screen) loader
  void showGlobal() => _incrementGlobal();

  /// Hide a global (full-screen) loader
  void hideGlobal() => _decrementGlobal();

  /// Show a scoped (per-button) loader
  void showScoped(String key) => _incrementScoped(key);

  /// Hide a scoped (per-button) loader
  void hideScoped(String key) => _decrementScoped(key);

  /// Generic start method (auto-detects type by key)
  void start(String key) {
    if (key.startsWith('loader.global')) {
      _incrementGlobal();
    } else {
      _incrementScoped(key);
    }
  }

  /// Generic stop method (auto-detects type by key)
  void stop(String key) {
    if (key.startsWith('loader.global')) {
      _decrementGlobal();
    } else {
      _decrementScoped(key);
    }
  }

  // ---------------------------------------------------------------------------
  // 🔒 Private Helpers
  // ---------------------------------------------------------------------------

  void _incrementGlobal() {
    globalCounter.value++;
  }

  void _decrementGlobal() {
    globalCounter.value = (globalCounter.value - 1)
        .clamp(0, double.infinity)
        .toInt();
  }

  void _incrementScoped(String key) {
    final map = Map<String, int>.from(scopedCounters.value);
    map[key] = (map[key] ?? 0) + 1;
    scopedCounters.value = map;
  }

  void _decrementScoped(String key) {
    final map = Map<String, int>.from(scopedCounters.value);
    if (map.containsKey(key)) {
      map[key] = (map[key]! - 1).clamp(0, double.infinity).toInt();
      if (map[key] == 0) map.remove(key);
      scopedCounters.value = map;
    }
  }

  /// Clear all scoped and global loaders
  void clearAll() {
    globalCounter.value = 0;
    scopedCounters.value = {};
  }
}
