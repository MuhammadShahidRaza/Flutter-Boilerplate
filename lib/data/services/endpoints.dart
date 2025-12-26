class Endpoints {
  // Auth
  static const String login = 'user/login';
  static const String register = 'user/register';
  static const String profile = 'user/user/user';
  static const String verifyOtp = 'user/verify-otp';

  // Home
  static const String banners = 'user/banner';
  static const String categories = 'user/category';
  static const String services = 'user/service';
  static const String addAddress = 'user/address/create';
  static const String updateAddress = 'user/address';
  static const String addresses = 'user/address';

  // User
  static const String getUserProfile = "user/user/user/user";
  static const String updateUserProfile = "user/user/update";

  // Orders
  static const String getOrders = "user/booking";
  static const String createOrder = "user/booking/create";
  static const String updateOrder = "user/orders/update";
  static const String updatePayment = "user/booking/";

  //SETTINGS
  static const String notifications = "user/notification";
  static const String settings = "user/setting";
  static const String slots = "user/slot";
  static const String additionalInfo = "user/additional-info";
  static const String contactUs = "user/contact/create";
  static const String privacyPolicy = "user/content/privacy-policy";
  static const String termsAndConditions = "user/content/terms-conditions";
  static const String deleteAccount = "user/user/delete-account";
  static const String logout = "user/user/logout";
}
