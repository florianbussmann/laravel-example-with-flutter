import 'package:flutter/material.dart';
import 'package:flutter_application/services/api.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late ApiService apiService;

  AuthProvider() {
    apiService = ApiService();
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirm, String deviceName) async {
    String token = await apiService.register(
        name, email, password, passwordConfirm, deviceName);
    isAuthenticated = true;
    notifyListeners();

    return token;
  }

  Future<String> login(String email, String password, String deviceName) async {
    String token = await apiService.login(email, password, deviceName);
    isAuthenticated = true;
    notifyListeners();

    return token;
  }
}
