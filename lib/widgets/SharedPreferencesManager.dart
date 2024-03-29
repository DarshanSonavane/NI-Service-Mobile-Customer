import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _instance;

  static Future<void> initialize() async {
    _instance = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance {
    if (_instance == null) {
      throw Exception('SharedPreferences has not been initialized.');
    }
    return _instance;
  }
}