import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/data/user_storage.dart';
import 'package:iot_flutter/features/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserStorage _userStorage;

  ProfileCubit(this._userStorage) : super(ProfileInitial()) {
    loadUser();
  }

  void loadUser() {
    final user = UserStorage.loggedUser;
    if (user != null) {
      emit(ProfileLoaded(user: user));
    } else {
      emit(ProfileError('User not logged in'));
    }
  }

  void toggleEdit(bool isEditing) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(ProfileLoaded(user: current.user, isEditing: isEditing));
    }
  }

  Future<void> updateUserName(String newName) async {
    if (state is! ProfileLoaded) return;

    final current = state as ProfileLoaded;
    final updatedUser = current.user.copyWith(name: newName.trim());

    try {
      await _userStorage.updateUser(updatedUser);
      emit(ProfileLoaded(user: updatedUser));
    } catch (e) {
      emit(ProfileError('Failed to update name: ${e.toString()}'));
      emit(ProfileLoaded(user: current.user));
    }
  }

  Future<void> logout() async {
    try {
      await _userStorage.logoutUser();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError('Logout error: ${e.toString()}'));
    }
  }
}
