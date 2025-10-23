class Endpoints {
  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String refreshToken = 'refresh';
  static const String profile = 'profile';
  static const String verifyOtp = 'verify-otp';

  // User
  static const String getUserProfile = "/user/profile";
  static const String updateUserProfile = "user/update";

  // Orders
  static const String getOrders = "/orders";
  static const String createOrder = "/orders/create";
  static const String updateOrder = "/orders/update";

  //SETTINGS
  static const String getSettings = "/settings";
  static const String contactUs = "/contact-us";
}
