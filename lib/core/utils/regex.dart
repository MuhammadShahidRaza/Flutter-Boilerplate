class AppRegex {
  /// Email: supports Unicode letters, marks, digits
  static const String email =
      r'^(?![.])([\p{L}\p{M}\p{N}_%+]+(?:\.[\p{L}\p{M}\p{N}_%+]+)*)@'
      r'[\p{L}\p{M}\p{N}-]+(?:\.[\p{L}\p{M}\p{N}-]+)*\.[\p{L}]{2,}$';

  /// Password: at least 8 chars, contains letters, digits, special chars
  // static const String password =
  //     r'^(?=.*[\p{L}\p{M}])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$';

  static const String password =
      r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$';

  /// URL (basic check, requires at least .com or other TLD)
  static const String url =
      r'^(https?:\/\/)?([\p{L}\p{M}\p{N}-]+\.)+[\p{L}]{2,}$';

  /// Credit card number (16 digits, grouped in 4s)
  static const String cardNumber = r'^\d{4} \d{4} \d{4} \d{4}$';

  /// Phone: digits only, 7–16 characters
  static const String phoneNumber = r'^\d{7,16}$';

  /// Username: Unicode letters, digits, underscore
  // static const String username = r'^[\p{L}\p{M}\p{N}_]+$';

  static const String username = r'^[\p{L}\p{N}_]+$';

  /// 6-digit verification code
  static const String verification = r'^\d{6}$';

  /// Expiry date (MM/YY)
  static const String expiryDate = r'^(0[1-9]|1[0-2])\/\d{2}$';

  /// CVV (3 digits)
  static const String cvv = r'^\d{3}$';

  /// Whitespace
  static const String removeSpaces = r'\s';

  /// Name: allows letters, marks, spaces, apostrophe, hyphen
  static const String firstName = r"^[\p{L}\p{M}'-]+(?: [\p{L}\p{M}'-]+)*$";
}
