import 'package:iot_flutter/core/model/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final bool isEditing;

  ProfileLoaded({required this.user, this.isEditing = false});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileLogoutSuccess extends ProfileState {}
