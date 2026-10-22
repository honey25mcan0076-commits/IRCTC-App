import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookingStorage {
  static const String _key = 'my_bookings';

  static Future<List<Map<String, dynamic>>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addBooking(
    Map<String, dynamic> booking,
  ) async {
    final bookings = await getBookings();

    bookings.insert(0, booking);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(bookings),
    );
  }

  static Future<void> cancelBooking(
    String pnr,
  ) async {
    final bookings = await getBookings();

    for (final booking in bookings) {
      if (booking['pnr'] == pnr) {
        booking['status'] = 'Cancelled';
      }
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(bookings),
    );
  }
}