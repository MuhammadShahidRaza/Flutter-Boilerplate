import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/routes/app_routes.dart';
import 'package:sanam_laundry/presentation/screens/auth/index.dart';
import 'package:sanam_laundry/presentation/screens/common/splash.dart';
import 'package:sanam_laundry/presentation/screens/user/home.dart';

class GoRouterSetup {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // Auth stack
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const Onboarding(),
      ),
      GoRoute(
        path: AppRoutes.getStarted,
        builder: (context, state) => const GetStarted(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUp(),
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

    // // Redirect based on login state
    // redirect: (context, state) async {
    //   final authProvider = context.read<AuthProvider>();
    //   if (!authProvider.isLoggedIn) return AppRoutes.login;
    //   if (state.uri.toString() == AppRoutes.login) return AppRoutes.home;
    //   // No redirect
    //   return null;
    // },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
