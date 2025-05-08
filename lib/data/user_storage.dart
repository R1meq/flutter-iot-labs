import 'dart:convert';

import 'package:iot_flutter/data/i_user_storage.dart';
import 'package:iot_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage implements IUserStorage {
  static const _userKey = 'users';
  static const _isLoggedInKey = 'is_logged_in';
  static const _loggedInEmailKey = 'logged_in_email';
  static const _loggedInUserKey = 'logged_in_user';
  static User? loggedUser;

  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.add(user);
    loggedUser = user;

    final encoded = jsonEncode(users.map((e) => e.toJSON()).toList());
    await prefs.setString(_userKey, encoded);

    await _saveLoggedInUser(user);
  }

  @override
  Future<User?> login(String email, String password) async {
    loggedUser = await getUser(email, password);
    if (loggedUser != null) {
      await _saveLoggedInUser(loggedUser!);
    }
    return loggedUser;
  }

  @override
  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (!isLoggedIn) return null;

    final userData = prefs.getString(_loggedInUserKey);
    if (userData != null) {
      try {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        loggedUser = User.fromJSON(userJson);
        return loggedUser;
      } catch (e) {
        await logoutUser();
        return null;
      }
    }
    return null;
  }

  @override
  Future<User?> getUser(String email, String password) async {
    final users = await getUsers();
    try {
      final user = users.firstWhere(
            (user) => (user.password == password && user.email == email),
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);

    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => User.fromJSON(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> updateUser(User updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    final index = users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      users[index] = updatedUser;
      final encoded = jsonEncode(users.map((e) => e.toJSON()).toList());
      await prefs.setString(_userKey, encoded);
      if (loggedUser != null && loggedUser!.id == updatedUser.id) {
        loggedUser = updatedUser;
        await _saveLoggedInUser(updatedUser);
      }
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    loggedUser = null;
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_loggedInEmailKey);
    await prefs.remove(_loggedInUserKey);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> _saveLoggedInUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_loggedInEmailKey, user.email);
    await prefs.setString(_loggedInUserKey, jsonEncode(user.toJSON()));
  }
}
