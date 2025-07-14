import 'package:shared_preferences/shared_preferences.dart';

class MileageStorage {
  static const String _key = 'mileageStored';

  static Future<double?> getMileage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key);
  }

  static Future<bool> setMileage(double value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setDouble(_key, value);
  }
}
