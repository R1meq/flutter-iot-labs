import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/component/custom_text_field.dart';
import 'package:iot_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:iot_flutter/features/auth/cubit/auth_state.dart';
import 'package:iot_flutter/features/auth/utils/validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkIfAlreadyLoggedIn();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Email',
              controller: emailController,
              validator: validateEmail,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Password',
              controller: passwordController,
              obscure: true,
              validator: validatePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: const Text('Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
