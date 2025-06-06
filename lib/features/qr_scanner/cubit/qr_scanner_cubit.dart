import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/utils/usb_serial_service.dart';
import 'package:iot_flutter/features/qr_scanner/cubit/qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QRScannerState> {
  final UsbSerialService _usbService;

  QRScannerCubit(this._usbService) : super(QRInitial());

  Future<void> handleQRCode(String qrData) async {
    if (state is QRLoading || state is QRSuccess) return;

    emit(QRLoading(qrData));

    final success = await _usbService.sendMessage(qrData);
    if (success) {
      emit(QRSuccess(qrData));
    } else {
      emit(QRError('Failed to send QR code data to device'));
    }
  }

  void resetScanner() {
    emit(QRInitial());
  }

  @override
  Future<void> close() {
    _usbService.dispose();
    return super.close();
  }
}
