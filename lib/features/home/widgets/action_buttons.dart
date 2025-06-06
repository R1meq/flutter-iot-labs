import 'package:flutter/material.dart';
import 'package:iot_flutter/features/message/view/device_message_page.dart';
import 'package:iot_flutter/features/qr_scanner/view/qr_scanner_page.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddLocation;

  const ActionButtons({required this.onAddLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder:
                    (_) => const QRScannerPage(),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner, size: 20),
            label: const Text('Scan QR Code'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder:
                    (_) => const DeviceMessagePage(),
                ),
              );
            },
            icon: const Icon(Icons.message, size: 20),
            label: const Text('Device Messages',),
          ),
        ),
      ],
    );
  }
}
