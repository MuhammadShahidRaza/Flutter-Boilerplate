import 'package:flutter/widgets.dart';

class AppBottomSheetOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  AppBottomSheetOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
