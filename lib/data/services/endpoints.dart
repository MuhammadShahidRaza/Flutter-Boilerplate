class Endpoints {
  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String refreshToken = 'refresh';
  static const String profile = 'profile';
  static const String verifyOtp = 'verify-otp';

  // Home
  static const String banners = 'banner';
  static const String categories = 'category';

  // User
  static const String getUserProfile = "user/user";
  static const String updateUserProfile = "user/update";

  // Orders
  // static const String getOrders = "/orders";
  // static const String createOrder = "/orders/create";
  // static const String updateOrder = "/orders/update";

  //SETTINGS
  // static const String getSettings = "settings";
  static const String contactUs = "contact/create";
  static const String privacyPolicy = "content/privacy-policy";
  static const String termsAndConditions = "content/terms-conditions";
  static const String deleteAccount = "user/delete-account";
  static const String logout = "user/logout";
}
