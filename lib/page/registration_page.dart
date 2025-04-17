import 'package:flutter/material.dart';
import 'package:iot_flutter/component/custom_text_field.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text('Registration', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CustomTextField(label: 'Name'),
              const SizedBox(height: 10),
              const CustomTextField(label: 'Email'),
              const SizedBox(height: 10),
              const CustomTextField(label: 'Password', obscure: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
                child: Text('Register',
                    style: Theme.of(context).textTheme.bodyMedium, ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
