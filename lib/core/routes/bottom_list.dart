import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';

/// Returns translated bottom navigation items.
List<BottomNavigationBarItem> getBottomNavItems(BuildContext context) {
  return [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home_outlined),
      activeIcon: const Icon(Icons.home),
      label: context.tr(Common.home),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.local_laundry_service_outlined),
      activeIcon: const Icon(Icons.local_laundry_service),
      label: context.tr(Common.service),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.assignment_outlined),
      activeIcon: const Icon(Icons.assignment),
      label: context.tr(Common.myOrders),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.person_outline),
      activeIcon: const Icon(Icons.person),
      label: context.tr(Common.myAccount),
    ),
  ];
}
