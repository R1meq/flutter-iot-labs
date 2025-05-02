import 'package:flutter/material.dart';
import 'package:iot_flutter/constants/app_colors.dart';
import 'package:iot_flutter/data/location_measurement_storage.dart';
import 'package:iot_flutter/model/location_measurement_data.dart';

class LocationEditorPage extends StatefulWidget {
  final LocationMeasurementData location;

  const LocationEditorPage({required this.location, super.key});

  @override
  State<LocationEditorPage> createState() => _LocationEditorPageState();
}

class _LocationEditorPageState extends State<LocationEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocationMeasurementStorage();
  late TextEditingController _nameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.name);
    _locationController = TextEditingController(text: widget.location.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedLocation = LocationMeasurementData(
      id: widget.location.id,
      userId: widget.location.userId,
      name: _nameController.text,
      location: _locationController.text,
      temperature: widget.location.temperature,
      humidity: widget.location.humidity,
      airQuality: widget.location.airQuality,
    );

    try {
      await _storage.saveMeasurement(updatedLocation);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (e) {
      _showError('Failed to save location: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Location',
            style: Theme.of(context).textTheme.titleLarge, ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save, color: AppColors.primary),
            label: const Text('Save',
                style: TextStyle(color: AppColors.primary), ),
            onPressed: _saveLocation,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.label,
              validator: (value) => value!.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Address',
              icon: Icons.location_on,
              validator:
                  (value) => value!.isEmpty ? 'Address is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}
