import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/constants/app_colors.dart';
import 'package:iot_flutter/core/di/service_locator.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/features/location/cubit/location_editor_cubit.dart';
import 'package:iot_flutter/features/location/widgets/location_editor_form.dart';

class LocationEditorPage extends StatelessWidget {
  final LocationMeasurementData location;

  const LocationEditorPage({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationEditorCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Edit Location',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: LocationEditorForm(location: location),
        ),
      ),
    );
  }
}
