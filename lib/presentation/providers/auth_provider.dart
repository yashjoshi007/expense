import 'package:flutter/material.dart';
import '../../core/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = AuthService.isLoggedIn();

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> register(String username, String password) async {
    bool success = await AuthService.register(username, password);
    return success;
  }

  bool login(String username, String password) {
    if (AuthService.login(username, password)) {
      _isLoggedIn = true;
      AuthService.setLoggedIn(true);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    AuthService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
