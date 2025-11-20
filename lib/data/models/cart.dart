class CartItem {
  final int serviceId;
  int quantity;
  double amount;
  CartItem({required this.serviceId, this.quantity = 1, this.amount = 0});

  Map<String, dynamic> toMap(int index) {
    return {
      "services[$index][service_id]": serviceId,
      "services[$index][quantity]": quantity,
      "services[$index][amount]": amount,
    };
  }
}
