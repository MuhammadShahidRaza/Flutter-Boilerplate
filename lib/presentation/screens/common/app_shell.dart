import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      useScaffold: false,
      safeArea: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(child: navigationShell),
          AppBottomNavigation(
            items: getBottomNavItems(context),
            currentIndex: navigationShell.currentIndex,
            onItemSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: navigationShell.currentIndex == index,
              );
            },
          ),
        ],
      ),
    );
  }
}
