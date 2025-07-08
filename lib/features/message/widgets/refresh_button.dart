import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/features/message/cubit/device_message_cubit.dart';
import 'package:iot_flutter/features/message/cubit/device_message_state.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceMessageCubit, DeviceMessageState>(
      builder: (context, state) {
        final isLoading = state is DeviceMessageLoading;
        return IconButton(
          onPressed: isLoading
              ? null
              : () => context.read<DeviceMessageCubit>().fetchMessage(),
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        );
      },
    );
  }
}
