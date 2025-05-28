import 'package:flutter/material.dart';
import 'package:iot_flutter/utils/usb_serial_service.dart';

class DeviceMessageScreen extends StatefulWidget {
  const DeviceMessageScreen({super.key});

  @override
  State<DeviceMessageScreen> createState() => _DeviceMessageScreenState();
}

class _DeviceMessageScreenState extends State<DeviceMessageScreen> {
  final UsbSerialService _usbService = UsbSerialService();

  String _displayedMessage = 'Connecting to device...';
  bool _isLoadingData = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMessageFromDevice();
  }

  Future<void> _fetchMessageFromDevice() async {
    setState(() {
      _isLoadingData = true;
      _hasError = false;
    });

    final receivedMessage = await _usbService.requestData('GET');

    setState(() {
      _isLoadingData = false;
      if (receivedMessage != null) {
        _displayedMessage = receivedMessage.isEmpty
            ? 'No message received'
            : receivedMessage;
      } else {
        _displayedMessage = 'Failed to connect to device';
        _hasError = true;
      }
    });
  }

  @override
  void dispose() {
    _usbService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Messages'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _isLoadingData ? null : _fetchMessageFromDevice,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoadingData) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                const Text(
                  'Fetching data from ESP32...',
                  style: TextStyle(fontSize: 16),
                ),
              ] else ...[
                Icon(
                  _hasError ? Icons.error_outline : Icons.message,
                  size: 64,
                  color: _hasError ? Colors.red : Colors.blue,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _hasError ? 'Error' : 'Last Message',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _displayedMessage,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _fetchMessageFromDevice,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
