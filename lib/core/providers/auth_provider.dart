import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userName;
  String? _userPhone;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userPhone => _userPhone;

  Future<void> verifyPhone(String phone) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyCode(String phone, String code) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    if (code.length >= 4) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'mock_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('userName', 'Пользователь');
      await prefs.setString('userPhone', phone);
      _isAuthenticated = true;
      _userName = 'Пользователь';
      _userPhone = phone;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'mock_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString('userName', 'Пользователь');
    await prefs.setString('userPhone', phone);
    _isAuthenticated = true;
    _userName = 'Пользователь';
    _userPhone = phone;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isAuthenticated = false;
    _userName = null;
    _userPhone = null;
    notifyListeners();
  }
}
