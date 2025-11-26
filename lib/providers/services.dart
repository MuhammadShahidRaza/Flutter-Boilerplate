import 'package:flutter/foundation.dart';
import 'package:sanam_laundry/data/models/category.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/data/models/settings.dart';
import 'package:sanam_laundry/data/repositories/home.dart';

class ServicesProvider extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();

  // Typed categories
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  SettingsModel _settings = SettingsModel(
    normalDelivery: 2,
    expressDelivery: 1,
    freeDeliveryThreshold: 0,
    normalDeliveryDays: 2,
    expressDeliveryDays: 1,
    taxPercentage: 5,
  );
  SettingsModel get settings => _settings;

  bool _loading = false;
  bool get loading => _loading;

  final Map<String, List<ServiceItemModel>> _categoryServices = {};

  // Cached addresses and slots (session-level cache)
  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  List<SlotModel> _slots = [];
  List<SlotModel> get slots => _slots;

  List<ServiceItemModel> servicesForCategory(String categoryId) {
    // Return cached data if exists
    final cached = _categoryServices[categoryId];
    if (cached != null) return cached;

    // Otherwise, trigger a background fetch
    fetchServicesByCategoryId(categoryId);
    return []; // return empty until fetch completes
  }

  Future<void> fetchCategories() async {
    if (_categories.isNotEmpty) return;
    _loading = true;
    notifyListeners();

    final list = await _repo.getCategories();

    _categories = list ?? [];
    _loading = false;
    notifyListeners();

    for (var cat in list ?? []) {
      fetchServicesByCategoryId(cat.id);
    }
    notifyListeners();
  }

  Future<void> fetchSettings() async {
    final setting = await _repo.getSettings();
    _settings = setting;
    notifyListeners();
  }

  // Addresses
  Future<void> ensureAddresses({bool force = false}) async {
    if (_addresses.isNotEmpty && !force) return;
    final list = await _repo.getAddresses();
    _addresses = list ?? [];
    notifyListeners();
  }

  // Slots
  Future<void> ensureSlots({bool force = false}) async {
    if (_slots.isNotEmpty && !force) return;
    final list = await _repo.getSlots();
    // Repo returns List<SlotModel>
    _slots = (list as List?)?.cast<SlotModel>() ?? [];
    notifyListeners();
  }

  Future<void> fetchServicesByCategoryId(
    String categoryId, {
    bool force = false,
  }) async {
    if (categoryId.isEmpty) return;

    // Return cached data if exists and not forced
    if (!force && _categoryServices.containsKey(categoryId)) {
      return;
    }

    _loading = true;
    notifyListeners();

    final list = await _repo.getServicesByCategoryId(categoryId);

    _categoryServices[categoryId] = list ?? [];
    _loading = false;
    notifyListeners();
  }
}
