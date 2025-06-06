import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/component/custom_text_field.dart';
import 'package:iot_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:iot_flutter/features/auth/cubit/auth_state.dart';
import 'package:iot_flutter/features/auth/utils/validators.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),)
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _showSnackbar('Registration successful!');
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          _showSnackbar(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Name',
              controller: _nameController,
              validator: validateName,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              validator: validateEmail,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Password',
              obscure: true,
              controller: _passwordController,
              validator: validatePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register', style: textStyle),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text('Already have an account? Login', style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
