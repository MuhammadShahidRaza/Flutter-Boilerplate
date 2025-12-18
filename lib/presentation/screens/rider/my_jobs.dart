import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/list_view.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/presentation/components/job_card.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({super.key});

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  final RiderRepository _riderRepository = RiderRepository();
  List<OrderModel> orders = [];
  TextEditingController searchController = TextEditingController();
  bool isPickup = true;
  final List<SlotModel> slots = [];
  String selectedSlotId = '1';

  List<CategoryModel> categories = [];
  String? selectedCategoryId;
  bool loadingCategories = true;
  bool loadingOrders = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    slotsFuture();
  }

  Future<void> _loadCategories() async {
    final data = [
      {"id": "assigned", "title": Common.assigned},
      {"id": "completed", "title": Common.completed},
      {"id": "in_vehicle", "title": Common.ordersInVehicle},
    ];

    setState(() {
      categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      loadingCategories = false;
      selectedCategoryId = categories.first.id;
    });

    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      loadingOrders = true;
      orders = [];
    });

    final data = await _riderRepository.getOrders(
      type: isPickup ? "pickup" : "delivery",
      slotId: selectedSlotId,
      status: selectedCategoryId,
      search: searchController.text.trim(),
    );
    if (!mounted) return;
    setState(() {
      orders = data ?? [];
      loadingOrders = false;
    });
  }

  Future<void> slotsFuture() async {
    await _riderRepository.getSlots().then((value) {
      if (!mounted) return;
      setState(() {
        slots.clear();
        slots.addAll(value ?? []);
        if (slots.isNotEmpty) {
          selectedSlotId = slots.first.id;
        }
      });
      _loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      safeArea: false,
      heading: Common.myJobs,
      // showBackButton: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacingMSmall,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                AppInput(
                  controller: searchController,
                  hint: "Search Job By Order ID",
                  suffixIcon: AppIcon(
                    icon: Icons.search,
                    color: AppColors.primary,
                  ),
                  onChanged: (value) {
                    // Implement search functionality if needed
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.radiusXs,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Slots horizontal chips
                    Expanded(
                      child: slots.isEmpty
                          ? SizedBox()
                          : Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              height: 40,
                              child: AppListView(
                                state: AppListState(
                                  items: slots,
                                  loadingInitial: false,
                                  loadingMore: false,
                                  hasMore: false,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, item, index) {
                                  final s = slots[index];
                                  final selected = s.id == selectedSlotId;
                                  return GestureDetector(
                                    onTap: () {
                                      if (selectedSlotId == s.id) return;
                                      setState(() => selectedSlotId = s.id);
                                      _loadOrders();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 17,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: AppText(
                                        s.title ?? "",
                                        style: context.textTheme.bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: selected
                                                  ? AppColors.white
                                                  : AppColors.text,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),

                    // Pickup / Delivery toggle chips
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      height: 40,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isPickup) return;
                              setState(() => isPickup = true);
                              _loadOrders();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isPickup
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: AppText(
                                Common.pickUp,
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isPickup
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!isPickup) return;
                              setState(() => isPickup = false);
                              _loadOrders();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: !isPickup
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: AppText(
                                Common.delivery,

                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: !isPickup
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          TabList(
            tabWidth: 0.29,
            list: categories,
            selectedId: selectedCategoryId,
            onTap: (id) {
              if (selectedCategoryId != id) {
                setState(() => selectedCategoryId = id);
                _loadOrders();
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
                      return JobCard(
                        order: order,
                        type: isPickup ? "pickup" : "delivery",
                        tabType: selectedCategoryId,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
