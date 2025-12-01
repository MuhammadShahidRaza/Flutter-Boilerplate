import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

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
      GoRoute(
        path: AppRoutes.verification,
        builder: (context, state) => const Verification(),
      ),

      // App stack with persistent tab navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.services,
                builder: (context, state) => const Services(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const Orders(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myAccount,
                builder: (context, state) => MyAccount(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.contactUs,
        builder: (context, state) => const ContactUs(),
      ),
      GoRoute(
        path: AppRoutes.staticPage,
        builder: (context, state) => const StaticPage(),
      ),

      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfile(),
      ),
      GoRoute(
        path: AppRoutes.bookingDetails,
        builder: (context, state) => const BookingDetails(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.myAddress,
        builder: (context, state) => const MyAddress(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) => const OrderDetails(),
      ),
      GoRoute(
        path: AppRoutes.serviceItem,
        builder: (context, state) => const ServiceItem(),
      ),
      GoRoute(
        path: AppRoutes.additionalInformation,
        builder: (context, state) => const AdditionalInformation(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const ChangeLanguage(),
      ),
      GoRoute(
        path: AppRoutes.confirmation,
        builder: (context, state) => const Confirmation(),
      ),
    ],

    errorBuilder: (context, state) => AppWrapper(
      child: Center(child: AppText('${Common.pageNotFound}: ${state.error}')),
    ),
  );
}
