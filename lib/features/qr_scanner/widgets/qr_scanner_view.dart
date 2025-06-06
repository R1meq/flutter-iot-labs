import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/features/qr_scanner/cubit/qr_scanner_cubit.dart';
import 'package:iot_flutter/features/qr_scanner/cubit/qr_scanner_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerView extends StatelessWidget {
  const QRScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QRScannerCubit, QRScannerState>(
      listener: (context, state) {
        if (state is QRError) {
          showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MobileScanner(
                    onDetect: (barcodeCapture) {
                      final code = barcodeCapture.barcodes
                          .firstOrNull?.rawValue;
                      if (code != null && code.isNotEmpty) {
                        context.read<QRScannerCubit>().handleQRCode(code);
                      }
                    },
                  ),
                ),
              ),
            ),
            if (state is QRLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Sending QR code data...'),
                  ],
                ),
              )
            else if (state is QRSuccess)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green,
                        size: 48
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'QR code successfully sent!',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data: ${state.data}',
                      style: const TextStyle(fontSize: 14
                          , color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed:
                          () => context.read<QRScannerCubit>().resetScanner(),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Another Code'),
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Point your camera at a QR code to scan',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }
}
