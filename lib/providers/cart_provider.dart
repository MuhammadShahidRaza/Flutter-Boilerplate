import 'package:flutter/foundation.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  final List<CartItem> _addOns = [];

  List<CartItem> get addOns => _addOns;

  Map<String, dynamic> _orderItemsPayload = {};

  Map<String, dynamic> get orderItemsPayload => _orderItemsPayload;

  /// Call this to update a single field in the payload
  // void addOrderDetail(String key, dynamic value) {
  //   _orderItemsPayload = {..._orderItemsPayload, key: value};
  //   notifyListeners();
  // }

  void addOrderDetail(String key, dynamic value) {
    _orderItemsPayload[key] = value; // <-- SIMPLE DIRECT UPDATE
    notifyListeners();
  }

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + (item.amount * item.quantity));
  double get totalAddonsAmount =>
      _addOns.fold(0, (sum, item) => sum + (item.amount * item.quantity));

  void addService(ServiceItemModel service) {
    final existing = _items.indexWhere(
      (e) => e.serviceId == int.parse(service.id),
    );
    if (existing != -1) {
      _items[existing].quantity++;
    } else {
      _items.add(
        CartItem(
          serviceId: int.parse(service.id),
          serviceName: service.title,
          amount: double.tryParse(service.amount) ?? 0,
        ),
      );
    }
    notifyListeners();
  }

  void addAddOn(ServiceItemModel service) {
    final existing = _addOns.indexWhere(
      (e) => e.serviceId == int.parse(service.id),
    );
    if (existing != -1) {
      _addOns[existing].quantity++;
    } else {
      _addOns.add(
        CartItem(
          serviceId: int.parse(service.id),
          serviceName: service.title,
          amount: double.tryParse(service.amount) ?? 0,
        ),
      );
    }
    notifyListeners();
  }

  void removeService(ServiceItemModel service) {
    final existing = _items.indexWhere(
      (e) => e.serviceId == int.parse(service.id),
    );
    if (existing != -1) {
      if (_items[existing].quantity > 1) {
        _items[existing].quantity--;
      } else {
        _items.removeAt(existing);
      }
      notifyListeners();
    }
  }

  void removeAddOn(ServiceItemModel service) {
    final existing = _addOns.indexWhere(
      (e) => e.serviceId == int.parse(service.id),
    );
    if (existing != -1) {
      if (_addOns[existing].quantity > 1) {
        _addOns[existing].quantity--;
      } else {
        _addOns.removeAt(existing);
      }
      notifyListeners();
    }
  }

  Map<String, dynamic> toOrderPayload() {
    final payload = {..._orderItemsPayload};

    for (int i = 0; i < _items.length; i++) {
      payload.addAll(_items[i].toMap(i));
    }

    return payload;
  }

  /// Reset everything
  void clearOrder() {
    _orderItemsPayload = {};
    notifyListeners();
  }
}
