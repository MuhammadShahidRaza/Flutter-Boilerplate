class RiderEndpoints {
  // Auth
  static const String login = 'rider/login';
  static const String register = 'rider/register';
  static const String profile = 'rider/user/user';
  static const String verifyOtp = 'rider/verify-otp';

  // Home
  static const String banners = 'rider/banner';
  static const String categories = 'rider/category';
  static const String services = 'rider/service';
  static const String addAddress = 'rider/address/create';
  static const String updateAddress = 'rider/address';
  static const String addresses = 'rider/address';

  // User
  static const String getUserProfile = "rider/user/user/user";
  static const String updateUserProfile = "rider/user/update";

  // Orders
  static const String getHomeOrders = "rider/home";
  static const String getOrders = "rider/booking";
  static const String createOrder = "rider/booking/create";
  static const String updateOrder = "rider//orders/update";

  //SETTINGS
  static const String notifications = "rider/notification";
  static const String settings = "rider/setting";
  static const String slots = "rider/slots";
  static const String additionalInfo = "rider/additional-info";
  static const String contactUs = "rider/contact/create";
  static const String privacyPolicy = "rider/content/privacy-policy";
  static const String termsAndConditions = "rider/content/terms-conditions";
  static const String deleteAccount = "rider/user/delete-account";
  static const String logout = "rider/user/logout";
}
