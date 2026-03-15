// lib/core/utils/validators.dart

/// Input validation rules following Indian standards.
class Validators {
  Validators._();

  /// Valid Indian mobile: 6-9 start, 10 digits
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  /// OTP must be exactly 6 digits
  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Enter the 6-digit OTP';
    }
    return null;
  }

  /// Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (value.trim().length > 60) return 'Name is too long';
    return null;
  }

  /// Generic required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  /// Bill amount — positive number, max ₹1,00,000
  static String? billAmount(String? value) {
    if (value == null || value.isEmpty) return 'Bill amount is required';
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) return 'Enter a valid amount';
    if (amount > 100000) return 'Amount cannot exceed ₹1,00,000';
    return null;
  }

  /// Check if Indian phone number is valid (bool version)
  static bool isValidPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
  }
}
