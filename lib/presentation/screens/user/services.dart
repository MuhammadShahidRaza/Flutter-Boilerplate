import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWrapper(
      heading: 'Services',
      child: AppText('Explore laundry services and offers.'),
    );
  }
}
