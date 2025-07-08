import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/features/home/cubit/home_cubit.dart';
import 'package:iot_flutter/features/home/widgets/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: const Scaffold(
        body: HomeView(),
      ),
    );
  }
}
