abstract class DeviceMessageState {}

class DeviceMessageInitial extends DeviceMessageState {}

class DeviceMessageLoading extends DeviceMessageState {}

class DeviceMessageLoaded extends DeviceMessageState {
  final String message;

  DeviceMessageLoaded(this.message);
}

class DeviceMessageError extends DeviceMessageState {
  final String error;

  DeviceMessageError(this.error);
}
