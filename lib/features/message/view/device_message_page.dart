import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/features/message/cubit/device_message_cubit.dart';
import 'package:iot_flutter/features/message/widgets/device_message_view.dart';
import 'package:iot_flutter/features/message/widgets/refresh_button.dart';

class DeviceMessagePage extends StatelessWidget {
  const DeviceMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DeviceMessageCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Device Messages'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: const [
            RefreshButton(),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: DeviceMessageView(),
          ),
        ),
      ),
    );
  }
}
