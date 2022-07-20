import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> save({required String key, required var value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is String) sharedPreferences.setString(key, value);
    if (value is int) sharedPreferences.setInt(key, value);
    if (value is bool) sharedPreferences.setBool(key, value);
    if (value is double) sharedPreferences.setDouble(key, value);
    if (value is List<String>) sharedPreferences.setStringList(key, value);
    if (value is Map) sharedPreferences.setString(key, jsonEncode(value));
  }

  static Future get({required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}
