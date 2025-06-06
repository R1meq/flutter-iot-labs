import 'package:flutter/material.dart';
import 'package:iot_flutter/core/data/user_storage.dart';
import 'package:iot_flutter/features/common/widgets/navigation_helper.dart';

class AppStartupService {
  final UserStorage userStorage;

  AppStartupService({required this.userStorage});

  static Widget? _cachedScreen;
  static Future<Widget>? _initializationFuture;

  Future<Widget> getStartScreen() async {
    if (_cachedScreen != null) return _cachedScreen!;

    _initializationFuture ??= _init();
    return await _initializationFuture!;
  }

  Future<Widget> _init() async {
    try {
      final user = await userStorage.getLoggedInUser()
          .timeout(const Duration(seconds: 5));

      _cachedScreen = user != null
          ? const NavigationHelper(targetRoute: '/home')
          : const NavigationHelper(targetRoute: '/login');
    } catch (e) {
      debugPrint('Error initializing app: $e');
      _cachedScreen = const NavigationHelper(targetRoute: '/login');
    }

    return _cachedScreen!;
  }
}
