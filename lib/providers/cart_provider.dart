import 'package:flutter/foundation.dart';
import 'package:sanam_laundry/data/models/cart.dart';
import 'package:sanam_laundry/data/models/service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + (item.amount * item.quantity));

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

  Map<String, dynamic> toOrderPayload({
    required String deliveryType,
    required String pickupDatetime,
    required int pickupSlotId,
    required String deliveryDatetime,
    required int deliverySlotId,
    required int ironingId,
    required int starchId,
    required int clothesReturnedId,
    required String address,
    required String city,
    required String state,
    required double latitude,
    required double longitude,
    String? transactionId,
    String? transactionReference,
    String? specialInstructions,
  }) {
    final Map<String, dynamic> payload = {
      "delivery_type": deliveryType,
      "pickup_datetime": pickupDatetime,
      "pickup_slot_id": pickupSlotId,
      "delivery_datetime": deliveryDatetime,
      "delivery_slot_id": deliverySlotId,
      "ironing_id": ironingId,
      "starch_id": starchId,
      "clothes_returned_id": clothesReturnedId,
      "address": address,
      "city": city,
      "state": state,
      "latitude": latitude,
      "longitude": longitude,
      "transaction_id": transactionId ?? "",
      "transaction_reference": transactionReference ?? "",
      "special_instructions": specialInstructions ?? "",
    };

    for (int i = 0; i < _items.length; i++) {
      payload.addAll(_items[i].toMap(i));
    }

    return payload;
  }
}
