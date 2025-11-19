import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationX on BuildContext {
  /// Navigate with optional URL params or extra object
  void navigate(String route, {Map<String, dynamic>? params, Object? extra}) {
    if (extra != null) {
      // Pass object directly (Map, model, list, etc.)
      push(route, extra: extra);
      return;
    }

    if (params != null && params.isNotEmpty) {
      final uri = Uri(
        path: route,
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      push(uri.toString());
    } else {
      push(route);
    }
  }

  /// Replace with support for extra
  void replacePage(
    String route, {
    Map<String, dynamic>? params,
    Object? extra,
  }) {
    if (extra != null) {
      go(route, extra: extra);
      return;
    }

    if (params != null && params.isNotEmpty) {
      final uri = Uri(
        path: route,
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      go(uri.toString());
    } else {
      go(route);
    }
  }

  void popPage() => pop();

  void back() {
    if (GoRouter.of(this).canPop()) pop();
  }

  /// Only use getParam for primitives (string, int, bool)
  T? getParam<T>(String key) {
    final v = GoRouterState.of(this).uri.queryParameters[key];
    if (v == null) return null;
    if (T == bool) return (v == 'true' || v == '1') as T;
    if (T == int) return int.tryParse(v) as T?;
    if (T == double) return double.tryParse(v) as T?;
    return v as T;
  }

  T? getExtra<T>() {
    return GoRouterState.of(this).extra as T?;
  }
}
