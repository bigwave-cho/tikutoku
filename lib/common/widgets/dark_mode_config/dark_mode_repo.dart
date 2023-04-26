import 'package:shared_preferences/shared_preferences.dart';

class DarkModeRepository {
  static const String _isDark = "isDark";

  final SharedPreferences _preferences;

  DarkModeRepository(this._preferences);

  Future<void> setIsDark(bool value) async {
    _preferences.setBool(_isDark, value);
  }

  bool isDark() {
    return _preferences.getBool(_isDark) ?? false;
  }
}
