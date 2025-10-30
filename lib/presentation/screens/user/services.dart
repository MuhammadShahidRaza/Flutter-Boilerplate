import 'package:flutter/material.dart';
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
        {"id": "11", "name": "Washing"},
        {"id": "12", "name": "Ironing"},
        {"id": "13", "name": "Dry Cleaning"},
      ],
      "2" => [
        {"id": "21", "name": "Stitching"},
        {"id": "22", "name": "Alteration"},
      ],
      "3" => [
        {"id": "31", "name": "Polish"},
        {"id": "32", "name": "Repair"},
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
      // showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category["id"] == selectedCategoryId;

                return GestureDetector(
                  onTap: () {
                    if (selectedCategoryId != category["id"]) {
                      setState(() => selectedCategoryId = category["id"]);
                      _loadServices(category["id"]);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category["name"],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Services List
          Expanded(
            child: loadingServices
                ? const Center(child: CircularProgressIndicator())
                : services.isEmpty
                ? const Center(child: Text("No services available"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        child: ListTile(
                          title: Text(service["name"]),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            // Navigate to service detail or add to cart
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
