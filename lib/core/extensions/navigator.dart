import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationX on BuildContext {
  void replacePage(String route, {Map<String, dynamic>? params}) {
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

  void navigate(String route, {Map<String, dynamic>? params}) {
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

  void popPage() => pop();

  void back() {
    if (GoRouter.of(this).canPop()) pop();
  }

  T? getParam<T>(String key) {
    final v = GoRouterState.of(this).uri.queryParameters[key];
    if (v == null) return null;
    if (T == bool) return (v == 'true' || v == '1') as T;
    if (T == int) return int.tryParse(v) as T?;
    if (T == double) return double.tryParse(v) as T?;
    return v as T;
  }
}
