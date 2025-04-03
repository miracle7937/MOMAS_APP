import 'dart:convert';

import 'package:momaspayplus/domain/data/request/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/data/response/user_model.dart';

class SharedPreferenceHelper {
  static const String _keyUser = 'user';
  static const String _keyLogin = 'Login';
  static const String _token = 'TOKEN';
  static const String _balance = 'balance_visible';
  static const String _unit = 'unit_visible';

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
    prefs.remove(_token);
    // prefs.clear();
  }

  static Future<void> saveUser(Map user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, json.encode(user));
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(
      _keyUser,
    );
    return data == null ? null : User.fromJson(json.decode(data));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(_token);
    return data;
  }

  static Future<void> saveLogin(Map login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLogin, json.encode(login));
  }

  static Future<Login?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(
      _keyLogin,
    );
    return data == null ? null : Login.fromJson(json.decode(data));
  }

  static Future<bool> getBalanceVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_balance) ?? true;
  }

  static Future<void> saveBalanceVisibility(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_balance, isVisible);
  }

  static Future<bool> getUnitVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_unit) ?? true;
  }

  static Future<void> saveUnitVisibility(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_unit, isVisible);
  }
}
