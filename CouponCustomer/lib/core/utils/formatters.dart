// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

/// Utility formatters for Indian locale — currency, dates, distances.
class Formatters {
  Formatters._();

  static final _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final _dateFormatter = DateFormat('dd MMM yyyy');
  static final _timeFormatter = DateFormat('h:mm a');
  static final _dateTimeFormatter = DateFormat('dd MMM yyyy, h:mm a');

  /// ₹1,00,000 (Indian format)
  static String rupees(double amount) => _currencyFormatter.format(amount);
  static String rupeesFromInt(int amount) => rupees(amount.toDouble());

  /// "28 Feb 2025"
  static String date(DateTime date) => _dateFormatter.format(date);

  /// "2:30 PM"
  static String time(DateTime dt) => _timeFormatter.format(dt);

  /// "28 Feb 2025, 2:30 PM"
  static String dateTime(DateTime dt) => _dateTimeFormatter.format(dt);

  /// "1.2 km away"
  static String distance(double km) =>
      '${km.toStringAsFixed(1)} km away';

  /// "30%" 
  static String percent(int value) => '$value%';

  /// "45 days left"
  static String daysLeft(int days) =>
      days == 1 ? '1 day left' : '$days days left';

  /// Formats a phone number: "+91 98765 43210"
  static String phone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    }
    return raw;
  }

  /// Relative time: "2 hours ago", "just now"
  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60)  return 'just now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)    return '${diff.inHours}h ago';
    if (diff.inDays == 1)     return 'yesterday';
    if (diff.inDays < 7)      return '${diff.inDays}d ago';
    return date(dt);
  }
}
