import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWrapper(
      scrollable: true,
      heading: 'Profile',
      child: AppText('Manage your account details.'),
    );
  }
}
