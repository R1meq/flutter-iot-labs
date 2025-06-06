import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/constants/app_colors.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/features/home/cubit/home_cubit.dart';
import 'package:iot_flutter/features/home/cubit/home_state.dart';
import 'package:iot_flutter/features/home/widgets/action_buttons.dart';
import 'package:iot_flutter/features/home/widgets/empty_locations.dart';
import 'package:iot_flutter/features/home/widgets/locations_list.dart';
import 'package:iot_flutter/features/profile/view/profile_page.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final mqttStatus = (state is HomeLoaded)
            ? state.mqttStatus : 'Unknown';
        final locations = (state is HomeLoaded)
            ? state.locations : <LocationMeasurementData>[];
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'My Locations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              Chip(
                label: Text('MQTT: $mqttStatus'),
                backgroundColor: mqttStatus == 'Connected'
                    ? Colors.green.shade100
                    : Colors.red.shade100,
              ),
              IconButton(
                icon: const Icon(Icons.person, color: AppColors.primary),
                onPressed: () => Navigator.push(
                  context,
                    MaterialPageRoute<void>(builder:
                        (_) => const ProfilePage()
                    )
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: cubit.addLocation,
                tooltip: 'Add Location',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ActionButtons(onAddLocation: cubit.addLocation),
                const SizedBox(height: 30),
                Expanded(
                  child: locations.isEmpty
                      ? EmptyLocations(onAddLocation: cubit.addLocation) :
                  LocationsList(
                    locations: locations,
                    onDeleteLocation: cubit.deleteLocation,
                    onReloadLocations: cubit.loadLocations,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
