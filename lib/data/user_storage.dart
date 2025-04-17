import 'dart:convert';

import 'package:iot_flutter/data/i_user_storage.dart';
import 'package:iot_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage implements IUserStorage {
  static const _userKey = 'users';
  static const _isLoggedInKey = 'is_logged_in';
  static User? loggedUser;

  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.add(user);
    loggedUser = user;

    final encoded = jsonEncode(users.map((e) => e.toJSON()).toList());
    await prefs.setString(_userKey, encoded);
  }

  @override
  Future<User?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    loggedUser = await getUser(email, password);
    await prefs.setBool(_isLoggedInKey, true);

    return loggedUser;
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
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

}
