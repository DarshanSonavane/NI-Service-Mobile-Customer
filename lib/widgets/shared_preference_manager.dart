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

Future<void> clearExcept(String keyToKeep) async {
  final sharedPreferences = SharedPreferencesManager.instance;
  if (sharedPreferences != null) {
    // Get the value for the key you want to keep
    final valueToKeep = sharedPreferences.get(keyToKeep);

    // Clear all shared preferences
    await sharedPreferences.clear();

    // Restore the value for the key you wanted to keep
    if (valueToKeep != null) {
      if (valueToKeep is int) {
        sharedPreferences.setInt(keyToKeep, valueToKeep);
      } else if (valueToKeep is double) {
        sharedPreferences.setDouble(keyToKeep, valueToKeep);
      } else if (valueToKeep is bool) {
        sharedPreferences.setBool(keyToKeep, valueToKeep);
      } else if (valueToKeep is String) {
        sharedPreferences.setString(keyToKeep, valueToKeep);
      } else if (valueToKeep is List<String>) {
        sharedPreferences.setStringList(keyToKeep, valueToKeep);
      }
    }
  }
}