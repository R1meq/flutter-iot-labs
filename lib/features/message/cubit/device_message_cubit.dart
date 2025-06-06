import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/utils/usb_serial_service.dart';
import 'package:iot_flutter/features/message/cubit/device_message_state.dart';


class DeviceMessageCubit extends Cubit<DeviceMessageState> {
  final UsbSerialService _usbService;

  DeviceMessageCubit(this._usbService) : super(DeviceMessageInitial());

  Future<void> fetchMessage() async {
    emit(DeviceMessageLoading());

    final message = await _usbService.requestData('GET');

    if (message != null) {
      if (message.isEmpty) {
        emit(DeviceMessageLoaded('No message received'));
      } else {
        emit(DeviceMessageLoaded(message));
      }
    } else {
      emit(DeviceMessageError('Failed to connect to device'));
    }
  }

  @override
  Future<void> close() {
    _usbService.dispose();
    return super.close();
  }
}
