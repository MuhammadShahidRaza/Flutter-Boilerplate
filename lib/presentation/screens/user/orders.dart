import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/category.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final HomeRepository _homeRepository = HomeRepository();
  List<OrderModel> orders = [];

  Future<void> _loadOrders(status) async {
    setState(() {
      loadingOrders = true;
      orders = [];
    });

    final data = await _homeRepository.getOrders(status);
    if (!mounted) return;
    setState(() {
      orders = data ?? [];
      loadingOrders = false;
    });
  }

  List<CategoryModel> categories = [];

  String? selectedCategoryId;
  bool loadingCategories = true;
  bool loadingOrders = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = [
      {"id": "pending", "title": Common.inProgressOrder},
      {"id": "completed", "title": Common.completed},
    ];

    setState(() {
      categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      loadingCategories = false;
      selectedCategoryId = categories.first.id;
    });

    _loadOrders(selectedCategoryId!);
  }

  // Future<void> _loadOrders(String categoryId) async {
  //   setState(() {
  //     loadingOrders = true;
  //     orders = [];
  //   });

  //   // 🔹 Simulating service API per category
  //   await Future.delayed(const Duration(milliseconds: 800));
  //   final data = switch (categoryId) {
  //     "1" => [
  //       {
  //         "id": "11",
  //         "name": "Washing",
  //         "image": AppAssets.getStarted,
  //         "status": "in-progress",
  //       },
  //       {
  //         "id": "12",
  //         "name": "Ironing",
  //         "image": AppAssets.onboardingOne,
  //         "status": "in-progress",
  //       },
  //       {
  //         "id": "13",
  //         "name": "Dry Cleaning",
  //         "image": AppAssets.onboardingThree,
  //         "status": "in-progress",
  //       },
  //       {
  //         "id": "14",
  //         "name": "Stitching",
  //         "image": AppAssets.user,
  //         "status": "in-progress",
  //       },
  //     ],
  //     "2" => [
  //       {
  //         "id": "21",
  //         "name": "Stitching",
  //         "image": AppAssets.user,
  //         "status": "completed",
  //       },
  //       {
  //         "id": "22",
  //         "name": "Alteration",
  //         "image": AppAssets.logo,
  //         "status": "completed",
  //       },
  //     ],
  //     "3" => [
  //       {
  //         "id": "31",
  //         "name": "Polish",
  //         "image": AppAssets.logo,
  //         "status": "completed",
  //       },
  //       {
  //         "id": "32",
  //         "name": "Repair",
  //         "image": AppAssets.logo,
  //         "status": "completed",
  //       },
  //     ],
  //     _ => [],
  //   };

  //   setState(() {
  //     orders = data;
  //     loadingOrders = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      safeArea: false,
      heading: Common.myOrders,
      // showBackButton: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingMSmall,
        children: [
          // 🔹 Category Horizontal List
          // if (loadingCategories)
          //   const Center(
          //     child: Padding(
          //       padding: EdgeInsets.all(20),
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
          // else
          TabList(
            tabWidth: 0.37,
            list: categories,
            selectedId: selectedCategoryId,
            onTap: (id) {
              if (selectedCategoryId != id) {
                setState(() => selectedCategoryId = id);
                _loadOrders(id);
              }
            },
          ),

          // 🔹 Orders List
          Expanded(
            child: loadingOrders
                ? const Center(child: CircularProgressIndicator.adaptive())
                : orders.isEmpty
                ? const Center(child: AppText(Common.noDataAvailable))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(order: order);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
