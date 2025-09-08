import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/routes/app_routes.dart';
import 'package:sanam_laundry/screens/auth/login.dart';
import 'package:sanam_laundry/screens/user/home.dart';
import 'package:sanam_laundry/services/auth.dart';

class GoRouterSetup {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.login,
    routes: [
      // Auth stack
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Login(),
      ),

      // App stack using ShellRoute for nested navigation
      ShellRoute(
        builder: (context, state, child) => Scaffold(body: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const Home(),
          ),
        ],
      ),
    ],

    // Redirect based on login state
    redirect: (context, state) async {
      if (!AuthService.isLoggedIn) return AppRoutes.login;
      if (state.uri.toString() == AppRoutes.login) return AppRoutes.home;
      // No redirect
      return null;
    },

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
