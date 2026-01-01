import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final listCategories = context.read<ServicesProvider>().categories;
    if (listCategories.isNotEmpty && selectedCategoryId == null) {
      setState(() => selectedCategoryId = listCategories.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      heading: "Services",
      safeArea: false,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Dimens.spacingM,
        children: [
          Consumer<ServicesProvider>(
            builder: (context, serviceProvider, _) {
              final categories = serviceProvider.categories;
              return TabList(
                list: categories,
                selectedId: selectedCategoryId,
                onTap: (id) {
                  if (selectedCategoryId != id) {
                    setState(() => selectedCategoryId = id);
                  }
                },
              );
            },
          ),

          // 🔹 Services List
          Expanded(
            child: Consumer<ServicesProvider>(
              builder: (context, serviceProvider, _) {
                final categories = serviceProvider.categories;
                final services = serviceProvider.servicesForCategory(
                  selectedCategoryId ?? "",
                );

                // ✅ Auto-select first category once categories are loaded
                if (categories.isNotEmpty && selectedCategoryId == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      selectedCategoryId = categories.first.id;
                    });
                  });
                }

                return AppListView<ServiceItemModel>(
                  state: AppListState<ServiceItemModel>(
                    items: services,
                    loadingInitial: serviceProvider.loading,
                    loadingMore: false,
                    hasMore: false,
                  ),
                  onRefresh: () => serviceProvider.fetchServicesByCategoryId(
                    selectedCategoryId!,
                    force: true,
                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, item, index) {
                    final service = services[index];
                    return ServiceCard(service: service, showAddRemove: false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
