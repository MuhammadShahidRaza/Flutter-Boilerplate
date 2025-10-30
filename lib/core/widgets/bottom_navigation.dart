import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemSelected,
      items: items,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      showUnselectedLabels: true,
    );
  }
}
