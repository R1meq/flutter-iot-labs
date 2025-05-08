import 'package:flutter/material.dart';
import 'package:iot_flutter/component/custom_text_field.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/utils/network_monitor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userStorage = UserStorage();
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkAlreadyLoggedIn();
  }

  Future<void> _login() async {
    final bool isConnected = await NetworkMonitor.checkConnection();
    if (!isConnected) {
      if (!mounted) return;
      setState(() {
        isOffline = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'No internet connection available. Please check your network.',),),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final user = await _userStorage.login(
          emailController.text.trim(),
          passwordController.text,
        );
        if (!mounted) return;
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _checkAlreadyLoggedIn() async {
    final isLoggedIn = await _userStorage.isUserLoggedIn();
    if (isLoggedIn && UserStorage.loggedUser != null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                  obscure: true,
                  controller: passwordController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/registration'),
                  child: Text('Registration',
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
