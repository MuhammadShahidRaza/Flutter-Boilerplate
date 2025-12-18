import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/presentation/screens/rider/my_jobs.dart';
import 'package:sanam_laundry/presentation/screens/rider/rider_account.dart';
import 'package:sanam_laundry/presentation/screens/rider/rider_home.dart';
import 'package:sanam_laundry/presentation/screens/rider/rider_notification.dart';
import 'package:sanam_laundry/presentation/screens/rider/update_status.dart';
import 'package:sanam_laundry/presentation/screens/user/job_details.dart';

class UserShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const UserShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return AppShell(navigationShell: navigationShell, isRider: false);
  }
}

class RiderShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RiderShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return AppShell(navigationShell: navigationShell, isRider: true);
  }
}

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

      /// USER BOTTOM TABS
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            UserShell(navigationShell: navigationShell),

        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.home, builder: (_, __) => const Home()),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.services,
                builder: (_, __) => const Services(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (_, __) => const Orders(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myAccount,
                builder: (_, __) => const MyAccount(),
              ),
            ],
          ),
        ],
      ),

      /// RIDER BOTTOM TABS
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RiderShell(navigationShell: navigationShell),

        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.riderHome,
                builder: (_, __) => const RiderHome(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myJobs,
                builder: (_, __) => const MyJobs(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.riderAccount,
                builder: (_, __) => const RiderMyAccount(),
              ),
            ],
          ),
        ],
      ),

      // App stack with persistent tab navigation
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
        path: AppRoutes.jobDetails,
        builder: (context, state) => const JobDetails(),
      ),
      GoRoute(
        path: AppRoutes.riderNotifications,
        builder: (context, state) => const RiderNotificationScreen(),
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
        path: AppRoutes.updateStatus,
        builder: (context, state) => const UpdateStatus(),
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
