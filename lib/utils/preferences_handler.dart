import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHandler {
  static const String SORT_ORDER_KEY = 'sort_order';

  // Sort Order
  Future<void> setSortOrder(String order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SORT_ORDER_KEY, order);
  }

  Future<String> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SORT_ORDER_KEY) ?? 'timestamp';
  }
} 