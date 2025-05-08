import 'package:flutter/material.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/page/home_page.dart';
import 'package:iot_flutter/page/login_page.dart';
import 'package:iot_flutter/page/profile_page.dart';
import 'package:iot_flutter/page/registration_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialScreen = const LoadingScreen();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final userStorage = UserStorage();
      final user = await userStorage.getLoggedInUser()
          .timeout(const Duration(seconds: 5), onTimeout: () => null);

      if (user != null) {
        _initialScreen = const HomePage();
      } else {
        _initialScreen = const LoginPage();
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');
      _initialScreen = const LoginPage();
    } finally {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: LoadingScreen(),
      );
    }

    return MaterialApp(
      title: 'Measurement App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.lightBlue[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
      home: _initialScreen,
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginPage());
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
