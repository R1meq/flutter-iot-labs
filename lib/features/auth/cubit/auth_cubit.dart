import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iot_flutter/core/data/user_storage.dart';
import 'package:iot_flutter/core/model/user.dart';
import 'package:iot_flutter/core/utils/network_monitor.dart';
import 'package:iot_flutter/features/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserStorage _userStorage;

  AuthCubit(this._userStorage) : super(AuthInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final users = await _userStorage.getUsers();
      final emailExists = users.any((user) => user.email == email.trim());

      if (emailExists) {
        emit(AuthError('User with this email already exists'));
        return;
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      await _userStorage.registerUser(newUser);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError('Registration error: ${e.toString()}'));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final isConnected = await NetworkMonitor.checkConnection();
    if (!isConnected) {
      emit(AuthError('No internet connection. Please check your network.'));
      return;
    }

    try {
      final user = await _userStorage.login(email.trim(), password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError('Login error: ${e.toString()}'));
    }
  }

  Future<void> checkIfAlreadyLoggedIn() async {
    emit(AuthLoading());

    try {
      final isLoggedIn = await _userStorage.isUserLoggedIn();
      if (isLoggedIn && UserStorage.loggedUser != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError('Error checking login status: ${e.toString()}'));
    }
  }
}
