import 'package:hive/hive.dart';

class AuthService {
  static late Box _authBox;

  static Future<void> initHive() async {
    _authBox = await Hive.openBox('authBox');
  }

  static Future<bool> register(String username, String password) async {
    if (_authBox.containsKey(username)) return false; // User already exists

    await _authBox.put(username, password);
    return true;
  }

  static bool login(String username, String password) {
    return _authBox.get(username) == password;
  }

  static Future<void> logout() async {
    await _authBox.put('isLoggedIn', false);
  }

 static bool isLoggedIn() {
  return _authBox.get('isLoggedIn', defaultValue: false) ?? false;
}

  static Future<void> setLoggedIn(bool value) async {
    await _authBox.put('isLoggedIn', value);
  }
}
