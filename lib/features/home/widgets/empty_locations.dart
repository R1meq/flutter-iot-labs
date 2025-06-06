import 'package:flutter/material.dart';

class EmptyLocations extends StatelessWidget {
  final VoidCallback onAddLocation;

  const EmptyLocations({required this.onAddLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No locations yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Location'),
            onPressed: onAddLocation,
          ),
        ],
      ),
    );
  }
}
