import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/features/qr_scanner/cubit/qr_scanner_cubit.dart';
import 'package:iot_flutter/features/qr_scanner/widgets/qr_scanner_view.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QRScannerCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const QRScannerView(),
      ),
    );
  }
}
