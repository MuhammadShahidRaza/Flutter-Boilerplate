import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/components/slider.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/services.dart';
import 'package:sanam_laundry/data/models/category.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeRepository _homeRepository = HomeRepository();
  int seletedItemIndex = 0;
  List<String> list = [];

  void fetchHomeData() async {
    final data = await _homeRepository.getBannners();

    if (!mounted) return;
    setState(() {
      list = data ?? [];
    });

    context.read<ServicesProvider>().fetch();
  }

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = context.watch<ServicesProvider>();
    final List<CategoryModel?> categories = categoriesState.categories;

    return AppWrapper(
      safeArea: false,
      scrollable: true,
      appBar: HomeAppBar(
        onNotificationTap: () => context.navigate(AppRoutes.notifications),
      ),
      child: Column(
        spacing: Dimens.spacingS,
        children: [
          SliderList(list: list),
          AppText(Common.categories, fontSize: 20, fontWeight: FontWeight.bold),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
              child: const MessageBox(
                icon: Icons.info_outline,
                title: 'No categories',
                value: 'Categories will appear here once available.',
              ),
            )
          else
            ListView.separated(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
              separatorBuilder: (_, __) => SizedBox(height: Dimens.spacingS),
              itemBuilder: (context, index) {
                final item = categories[index];
                final isSelected = index == seletedItemIndex;
                return CategoryCard(
                  data: item!,
                  onTap: () {
                    setState(() {
                      seletedItemIndex = index;
                    });
                  },
                  isSelected: isSelected,
                );
              },
            ),
        ],
      ),
    );
  }
}
