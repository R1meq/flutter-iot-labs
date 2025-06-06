import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/features/message/cubit/device_message_cubit.dart';
import 'package:iot_flutter/features/message/cubit/device_message_state.dart';
import 'package:iot_flutter/features/message/widgets/loading_state.dart';
import 'package:iot_flutter/features/message/widgets/result_state.dart';

class DeviceMessageView extends StatelessWidget {
  const DeviceMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    fetchMessage() => context.read<DeviceMessageCubit>().fetchMessage();
    return BlocBuilder<DeviceMessageCubit, DeviceMessageState>(
      builder: (context, state) {
        if (state is DeviceMessageInitial || state is DeviceMessageLoading) {
          return const LoadingState();
        } else if (state is DeviceMessageLoaded) {
          return ResultState(
            icon: Icons.message,
            iconColor: Colors.blue,
            title: 'Last Message',
            content: state.message,
            onRefresh: fetchMessage,
          );
        } else if (state is DeviceMessageError) {
          return ResultState(
            icon: Icons.error_outline,
            iconColor: Colors.red,
            title: 'Error',
            content: state.error,
            onRefresh: fetchMessage,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
