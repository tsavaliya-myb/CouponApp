// lib/core/utils/extensions.dart

extension StringExtensions on String {
  /// Capitalizes first letter, rest lowercase
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Title case: "food and drinks" → "Food And Drinks"
  String get titleCase =>
      split(' ').map((w) => w.capitalized).join(' ');

  /// Returns initials: "Rahul Sharma" → "RS"
  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Masks a phone number: "9876543210" → "98765 *****"
  String get maskedPhone {
    if (length < 10) return this;
    return '${substring(0, 5)} *****';
  }

  /// Strips non-digit characters
  String get digitsOnly => replaceAll(RegExp(r'\D'), '');

  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;
}

extension DateTimeExtensions on DateTime {
  /// "28 Feb 2025"
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isExpired => isBefore(DateTime.now());

  /// Days until this date (0 if expired)
  int get daysUntil =>
      isExpired ? 0 : difference(DateTime.now()).inDays.clamp(0, 9999);

  bool get isExpiringSoon => daysUntil <= 7 && !isExpired;
}

extension NumExtensions on num {
  /// Clamps to 0 minimum
  num get atLeastZero => clamp(0, double.infinity);
}

extension IterableExtensions<T> on Iterable<T> {
  /// Returns null if empty instead of throwing
  T? get firstOrNull => isEmpty ? null : first;
}
