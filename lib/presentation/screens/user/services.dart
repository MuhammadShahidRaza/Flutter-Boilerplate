import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<Map<String, dynamic>> categories = [];
  List<dynamic> services = [];

  String? selectedCategoryId;
  bool loadingCategories = true;
  bool loadingServices = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // 🔹 Simulating API call
    await Future.delayed(const Duration(milliseconds: 800));
    final data = [
      {"id": "1", "name": "Laundry"},
      {"id": "2", "name": "Tailoring"},
      {"id": "3", "name": "Shoe Care"},
    ];

    setState(() {
      categories = data;
      loadingCategories = false;
      selectedCategoryId = data.first["id"];
    });

    _loadServices(selectedCategoryId!);
  }

  Future<void> _loadServices(String categoryId) async {
    setState(() {
      loadingServices = true;
      services = [];
    });

    // 🔹 Simulating service API per category
    await Future.delayed(const Duration(milliseconds: 800));
    final data = switch (categoryId) {
      "1" => [
        {"id": "11", "name": "Washing", "image": AppAssets.getStarted},
        {"id": "12", "name": "Ironing", "image": AppAssets.onboardingOne},
        {
          "id": "13",
          "name": "Dry Cleaning",
          "image": AppAssets.onboardingThree,
        },
        {"id": "14", "name": "Stitching", "image": AppAssets.user},
      ],
      "2" => [
        {"id": "21", "name": "Stitching", "image": AppAssets.user},
        {"id": "22", "name": "Alteration", "image": AppAssets.logo},
      ],
      "3" => [
        {"id": "31", "name": "Polish", "image": AppAssets.logo},
        {"id": "32", "name": "Repair", "image": AppAssets.logo},
      ],
      _ => [],
    };

    setState(() {
      services = data;
      loadingServices = false;
    });
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
          TabList(
            list: categories,
            selectedId: selectedCategoryId,
            onTap: (id) {
              if (selectedCategoryId != id) {
                setState(() => selectedCategoryId = id);
                _loadServices(id);
              }
            },
          ),

          // 🔹 Services List
          Expanded(
            child: loadingServices
                ? const Center(child: CircularProgressIndicator())
                : services.isEmpty
                ? const Center(child: AppText("No services available"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return ServiceCard(
                        service: service,
                        showAddRemove: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
