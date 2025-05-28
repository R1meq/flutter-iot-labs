import 'dart:typed_data';

import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class UsbSerialService {
  static const int _baudRate = 9600;
  static const int _dataBits = UsbPort.DATABITS_8;
  static const int _stopBits = UsbPort.STOPBITS_1;
  static const int _parity = UsbPort.PARITY_NONE;

  UsbPort? _usbPort;
  Transaction<String>? _dataTransaction;
  bool get isConnected => _usbPort != null;

  Future<bool> connectToDevice() async {
    try {
      final availableDevices = await UsbSerial.listDevices();

      if (availableDevices.isEmpty) {
        return false;
      }

      _usbPort = await availableDevices.first.create();
      final connectionResult = await _usbPort!.open();

      if (!connectionResult) {
        _usbPort = null;
        return false;
      }

      await _configurePortSettings();
      return true;
    } catch (e) {
      _usbPort = null;
      return false;
    }
  }

  Future<void> _configurePortSettings() async {
    if (_usbPort == null) return;
    await _usbPort!.setDTR(true);
    await _usbPort!.setRTS(true);
    await _usbPort!.setPortParameters(
      _baudRate,
      _dataBits,
      _stopBits,
      _parity,
    );
  }

  Future<bool> sendMessage(String message) async {
    if (_usbPort == null) {
      final connected = await connectToDevice();
      if (!connected) return false;
    }

    try {
      final messageBytes = Uint8List.fromList(message.codeUnits);
      await _usbPort!.write(messageBytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> requestData(String command) async {
    if (_usbPort == null) {
      final connected = await connectToDevice();
      if (!connected) return null;
    }

    try {
      final commandBytes = Uint8List.fromList('$command\n'.codeUnits);
      await _usbPort!.write(commandBytes);

      _dataTransaction = Transaction.stringTerminated(
        _usbPort!.inputStream!,
        Uint8List.fromList([13, 10]),
      );

      final response = await _dataTransaction!.stream.first
          .timeout(const Duration(seconds: 5));

      return response.trim();
    } catch (e) {
      return null;
    } finally {
      _dataTransaction?.dispose();
      _dataTransaction = null;
    }
  }

  void dispose() {
    _dataTransaction?.dispose();
    _usbPort?.close();
    _usbPort = null;
  }
}
