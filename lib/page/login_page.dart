import 'package:flutter/material.dart';
import 'package:iot_flutter/component/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.titleLarge, ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CustomTextField(label: 'Email'),
              const SizedBox(height: 10),
              const CustomTextField(label: 'Password', obscure: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
                child: Text('Login',
                    style: Theme.of(context).textTheme.bodyMedium, ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/registration'),
                child: Text('Registration',
                    style: Theme.of(context).textTheme.bodyMedium, ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
