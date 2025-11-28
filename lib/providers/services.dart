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

  Future<AddressModel?> addNewAddress(Map<String, dynamic> data) async {
    final created = await _repo.addNewAddress(data);
    if (created != null) {
      _addresses.add(created);
      notifyListeners();
    }
    return created;
  }

  Future<AddressModel?> updateAddress(Map<String, dynamic> data) async {
    final updated = await _repo.updateAddress(address: data, id: data['id']);

    if (updated != null) {
      final index = _addresses.indexWhere((a) => a.id == updated.id);
      if (index != -1) {
        _addresses[index] = updated; // ✅ Replace existing
      } else {
        _addresses.add(updated); // optional: only if not found
      }
      notifyListeners();
    }
    return updated;
  }

  // Future<AddressModel?> updateAddress(Map<String, dynamic> data) async {
  //   final updated = await _repo.updateAddress(address: data, id: data['id']);
  //   if (updated != null) {
  //     await ensureAddresses(force: true);
  //   }
  //   return updated;
  // }

  Future<void> deleteAddress(int id) async {
    _addresses.removeWhere((a) => a.id == id);
    await _repo.deleteAddress(id);
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

  void clear() {
    _addresses = [];
    notifyListeners();
  }
}
