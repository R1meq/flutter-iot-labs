import 'package:flutter/material.dart';
import 'package:iot_flutter/utils/usb_serial_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final UsbSerialService _usbService = UsbSerialService();

  bool _isSendingData = false;
  bool _hasScannedCode = false;
  String? _lastScannedCode;

  Future<void> _handleQRCodeDetection(String qrCodeData) async {
    if (_hasScannedCode) return;

    setState(() {
      _isSendingData = true;
      _lastScannedCode = qrCodeData;
    });

    final sendSuccess = await _usbService.sendMessage(qrCodeData);

    setState(() {
      _isSendingData = false;
      _hasScannedCode = sendSuccess;
    });

    if (!sendSuccess) {
      _showErrorDialog('Failed to send QR code data to device');
    }
  }

  void _resetScanner() {
    setState(() {
      _hasScannedCode = false;
      _lastScannedCode = null;
    });
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        title: const Text('QR Code Scanner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildScannerView(),
          ),
          _buildStatusSection(),
        ],
      ),
    );
  }
  Widget _buildScannerView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MobileScanner(
          onDetect: (BarcodeCapture barcodeCapture) {
            final detectedBarcode =
                barcodeCapture.barcodes.firstOrNull?.rawValue;
            if (detectedBarcode != null && detectedBarcode.isNotEmpty) {
              _handleQRCodeDetection(detectedBarcode);
            }
          },
        ),
      ),
    );
  }
  Widget _buildStatusSection() {
    if (_isSendingData) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Sending QR code data...'),
          ],
        ),
      );
    }
    if (_hasScannedCode) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'QR code successfully sent!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_lastScannedCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Data: $_lastScannedCode',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _resetScanner,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Another Code'),
            ),
          ],
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Point your camera at a QR code to scan',
        style: TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
