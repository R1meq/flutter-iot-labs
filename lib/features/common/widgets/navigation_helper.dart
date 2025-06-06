import 'package:flutter/cupertino.dart';
import 'package:iot_flutter/features/common/widgets/loading_screen.dart';

class NavigationHelper extends StatelessWidget {
  final String targetRoute;

  const NavigationHelper({required this.targetRoute, super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.name != targetRoute) {
        Navigator.of(context).pushReplacementNamed(targetRoute);
      }
    });

    return const LoadingScreen();
  }
}
