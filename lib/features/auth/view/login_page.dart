import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:iot_flutter/features/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
