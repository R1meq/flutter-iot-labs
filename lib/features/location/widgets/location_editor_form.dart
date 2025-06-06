import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/features/location/cubit/location_editor_cubit.dart';
import 'package:iot_flutter/features/location/cubit/location_editor_state.dart';
import 'package:iot_flutter/features/location/widgets/app_text_field.dart';
import 'package:iot_flutter/features/location/widgets/save_button.dart';

class LocationEditorForm extends StatefulWidget {
  final LocationMeasurementData location;

  const LocationEditorForm({required this.location, super.key});

  @override
  State<LocationEditorForm> createState() => _LocationEditorFormState();
}

class _LocationEditorFormState extends State<LocationEditorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final LocationEditorCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LocationEditorCubit>();
    _nameController = TextEditingController(text: widget.location.name);
    _locationController = TextEditingController(text: widget.location.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    final updatedLocation = widget.location.copyWith(
      name: _nameController.text,
      location: _locationController.text,
    );
    _cubit.saveLocation(updatedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationEditorCubit, LocationEditorState>(
      listener: (context, state) {
        if (state is LocationEditorSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (state is LocationEditorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.label,
                  validator: (value) =>
                  value!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _locationController,
                  label: 'Address',
                  icon: Icons.location_on,
                  validator: (value) =>
                  value!.isEmpty ? 'Address is required' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<LocationEditorCubit, LocationEditorState>(
            builder: (context, state) {
              final isLoading = state is LocationEditorLoading;
              return SaveButton(
                isLoading: isLoading,
                onPressed: _submitForm,
              );
            },
          ),
        ],
      ),
    );
  }
}
