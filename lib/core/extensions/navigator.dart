import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationX on BuildContext {
  /// Replace current route with a new route
  void replacePage(String route, {Map<String, String>? params}) {
    if (params != null && params.isNotEmpty) {
      final uri = Uri(path: route, queryParameters: params);
      go(uri.toString());
    } else {
      go(route);
    }
  }

  /// Push a new route on top of the stack
  void navigate(String route, {Map<String, String>? params}) {
    if (params != null && params.isNotEmpty) {
      final uri = Uri(path: route, queryParameters: params);
      push(uri.toString());
    } else {
      push(route);
    }
  }

  /// Pop the current page
  void popPage() => pop();

  /// Go back safely
  void back() {
    if (GoRouter.of(this).canPop()) pop();
  }

  T? getParam<T>(String key) {
    final state = GoRouterState.of(this);
    final value = state.uri.queryParameters[key] ?? state.pathParameters[key];
    return value as T?;
  }
}
