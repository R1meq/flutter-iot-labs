import 'package:iot_flutter/model/user.dart';

abstract class IUserStorage {
  Future<void> registerUser(User user);
  Future<User?> login(String email, String password);
  Future<User?> getUser(String email, String password);
  Future<List<User>> getUsers();
  Future<void> logoutUser();
  Future<bool> isUserLoggedIn();
  Future<void> updateUser(User updatedUser);
}
