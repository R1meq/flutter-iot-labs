import 'package:flutter/material.dart';

class ResultState extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final VoidCallback onRefresh;

  const ResultState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: iconColor),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh Data'),
        ),
      ],
    );
  }
}
