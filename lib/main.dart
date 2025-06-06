import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/core/utils/app_startup_service.dart';
import 'package:iot_flutter/features/auth/view/login_page.dart';
import 'package:iot_flutter/features/auth/view/registration_page.dart';
import 'package:iot_flutter/features/common/widgets/loading_screen.dart';
import 'package:iot_flutter/features/common/widgets/navigation_helper.dart';
import 'package:iot_flutter/features/home/view/home_page.dart';
import 'package:iot_flutter/features/profile/view/profile_page.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const AppInitializer(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final startupService = getIt<AppStartupService>();

    return FutureBuilder<Widget>(
      future: startupService.getStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingScreen();
        }
        return snapshot.data ?? const NavigationHelper(targetRoute: '/login');
      },
    );
  }
}
