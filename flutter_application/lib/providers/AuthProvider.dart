import 'package:flutter/material.dart';
import 'package:flutter_application/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;
  late ApiService apiService;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    token = await getToken();
    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirm, String deviceName) async {
    token = await apiService.register(
        name, email, password, passwordConfirm, deviceName);
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String email, String password, String deviceName) async {
    token = await apiService.login(email, password, deviceName);
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }
}
