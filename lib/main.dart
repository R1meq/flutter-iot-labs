import 'package:flutter/material.dart';
import 'package:iot_flutter/page/home_page.dart';
import 'package:iot_flutter/page/login_page.dart';
import 'package:iot_flutter/page/profile_page.dart';
import 'package:iot_flutter/page/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measurement App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.lightBlue[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
      initialRoute: '/registration',
      routes: {
        '/login': (ctx) => const LoginPage(),
        '/registration': (ctx) => const RegistrationPage(),
        '/profile': (ctx) => const ProfilePage(),
        '/home': (ctx) => const HomePage(),
      },
    );
  }
}
