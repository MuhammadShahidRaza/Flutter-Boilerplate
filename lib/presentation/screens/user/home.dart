import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
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

  Future<void> fetchBanners() async {
    final data = await _homeRepository.getBannners();
    if (!mounted) return;
    setState(() => list = data ?? []);
  }

  Future<void> fetchCategories() async {
    context.read<ServicesProvider>().fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = context.watch<ServicesProvider>();
    final List<CategoryModel> categories = serviceProvider.categories;

    return AppWrapper(
      safeArea: false,
      scrollable: true,
      appBar: HomeAppBar(
        onNotificationTap: () => context.navigate(AppRoutes.notifications),
      ),
      child: Column(
        spacing: Dimens.spacingS,
        children: [
          if (list.isNotEmpty) SliderList(list: list),
          AppText(Common.categories, fontSize: 20, fontWeight: FontWeight.bold),
          AppListView<CategoryModel>(
            state: AppListState<CategoryModel>(
              items: categories,
              loadingInitial: serviceProvider.loading,
              loadingMore: false,
              hasMore: false,
            ),
            separatorBuilderWidget: const SizedBox(height: Dimens.spacingS),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacingS),
            itemBuilder: (context, item, index) {
              final isSelected = index == seletedItemIndex;
              return CategoryCard(
                data: item,
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
