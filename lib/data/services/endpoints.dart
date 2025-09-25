class Endpoints {
  static const String baseUrl = "https://api.yourapp.com";

  // Auth
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String logout = "$baseUrl/auth/logout";

  // User
  static const String getUserProfile = "$baseUrl/user/profile";
  static const String updateUserProfile = "$baseUrl/user/update";

  // Orders
  static const String getOrders = "$baseUrl/orders";
  static const String createOrder = "$baseUrl/orders/create";
  static const String updateOrder = "$baseUrl/orders/update";

  // Add more endpoints here
}
