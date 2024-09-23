import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Preference? _instance;
  Preference._();

  static Preference get instance => _instance ?? Preference._();
  late SharedPreferences _preferences;

  dynamic getData(String key) async {
    _preferences = await SharedPreferences.getInstance();
    var value = _preferences.get(key);
    return value;
  }

  dynamic saveData<T>(String key, T content) async {
    _preferences = await SharedPreferences.getInstance();

    if (content != null) {
      if (content is String && (content.isNotEmpty)) {
        _preferences.setString(key, content);
      } else if (content is bool) {
        _preferences.setBool(key, content);
      } else if (content is int) {
        _preferences.setInt(key, content);
      } else {
        _preferences.setString(key, content.toString());
      }
    }
  }


  Future<void> clearAll() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences.clear();
  }
}
