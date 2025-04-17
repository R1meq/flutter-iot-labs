import 'package:flutter/material.dart';
import 'package:iot_flutter/component/custom_text_field.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/model/user.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userStorage = UserStorage();

  String? nameError;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final users = await _userStorage.getUsers();
        final emailExists = users
            .any((user) => user.email == emailController.text.trim());

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content:
            Text('User with this email already exists'), ),
          );
          return;
        }

        final newUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await _userStorage.registerUser(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration',
            style: Theme.of(context).textTheme.titleLarge, ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Name',
                  controller: nameController,
                  validator: validateName,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Email',
                  controller: emailController,
                  validator: validateEmail,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Password',
                  obscure: true,
                  controller: passwordController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Register',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text('Already have an account? Login',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name cannot be empty';
  }
  if (RegExp(r'[0-9]').hasMatch(value)) {
    return 'Name should not contain numbers';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}
}
