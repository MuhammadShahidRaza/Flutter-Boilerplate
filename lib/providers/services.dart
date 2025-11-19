import 'package:flutter/foundation.dart';
import 'package:sanam_laundry/data/models/category.dart';
import 'package:sanam_laundry/data/repositories/home.dart';

class ServicesProvider extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();

  // Typed categories
  List<CategoryModel?> _categories = [];
  List<CategoryModel?> get categories => _categories;

  Future<void> fetch({bool force = false}) async {
    // if (!force) return; // fetch-once by default
    // Using existing repository + response handler
    final data = await _repo.getCategories();

    // // `ApiResponseHandler` returns parsed `data` directly (dynamic)
    // // Expecting a list of category objects; map defensively
    // final list = <CategoryModel>[];
    // if (data is List<Map<String, dynamic>> || data == null) {
    //   final listData = data ?? const <Map<String, dynamic>>[];
    //   for (final map in listData) {
    //     list.add(CategoryModel.fromJson(map));
    //   }
    // }

    // _categories = list;
    _categories = data ?? [];
    notifyListeners();
  }

  Future<void> refresh() => fetch(force: true);
}
