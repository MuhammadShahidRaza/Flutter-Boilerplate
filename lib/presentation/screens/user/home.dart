import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/components/slider.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int seletedItemIndex = 0;
  final List<String> list = [AppAssets.temp, AppAssets.logo, AppAssets.user];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'Washing',
        'subtitle':
            'Your clothes are freshly washed and neatly folded.\nDelivered right to your doorstep.',
      },
      {
        'title': 'Dry Cleaning',
        'subtitle':
            'Premium dry cleaning in progress with gentle care.\nWe’ll notify you once it’s ready for pickup.',
      },
      {
        'title': 'Ironing',
        'subtitle':
            'Your garments are being perfectly pressed.\nThey’ll be ready for pickup soon.',
      },
    ];

    return AppWrapper(
      safeArea: false,
      scrollable: true,
      appBar: HomeAppBar(),
      child: Column(
        spacing: Dimens.spacingS,
        children: [
          SliderList(list: list),
          AppText(Common.categories, fontSize: 20, fontWeight: FontWeight.bold),
          ListView.separated(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
            separatorBuilder: (_, __) => SizedBox(height: Dimens.spacingS),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = index == seletedItemIndex;
              return CategoryCard(
                onTap: () {
                  setState(() {
                    seletedItemIndex = index;
                  });
                },
                description: item['subtitle'] ?? '',
                title: item['title'] ?? '',
                image: item['image'] ?? AppAssets.user,
                isSelected: isSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}
