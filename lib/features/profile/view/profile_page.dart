import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/features/profile/cubit/profile_cubit.dart';
import 'package:iot_flutter/features/profile/widgets/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style:
          Theme.of(context).textTheme.titleLarge,),
        ),
        body: const ProfileForm(),
      ),
    );
  }
}
