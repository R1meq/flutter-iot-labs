import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SaveButton({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: isLoading
          ? const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ) : const Text('Save'),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
