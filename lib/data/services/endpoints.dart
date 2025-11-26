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
  static const String services = 'service';
  static const String addAddress = 'address/create';
  static const String addresses = 'address';

  // User
  static const String getUserProfile = "user/user";
  static const String updateUserProfile = "user/update";

  // Orders
  static const String getOrders = "booking";
  static const String createOrder = "booking/create";
  static const String updateOrder = "/orders/update";

  //SETTINGS
  static const String settings = "setting";
  static const String slots = "slot";
  static const String additionalInfo = "additional-info";
  static const String contactUs = "contact/create";
  static const String privacyPolicy = "content/privacy-policy";
  static const String termsAndConditions = "content/terms-conditions";
  static const String deleteAccount = "user/delete-account";
  static const String logout = "user/logout";
}
