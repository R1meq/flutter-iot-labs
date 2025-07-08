import 'package:flutter/material.dart';
import 'package:iot_flutter/core/component/location_measurement_card.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/features/location/view/location_editor_page.dart';

class LocationsList extends StatelessWidget {
  final List<LocationMeasurementData> locations;
  final void Function(String locationId) onDeleteLocation;
  final VoidCallback onReloadLocations;

  const LocationsList({
    required this.locations,
    required this.onDeleteLocation,
    required this.onReloadLocations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return Dismissible(
          key: Key(location.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDeleteLocation(location.id),
          child: GestureDetector(
            onTap: () async {
              final edited = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationEditorPage(location: location),
                ),
              );
              if (edited ?? false) {
                onReloadLocations();
              }
            },
            child: LocationMeasurementCard(
              name: location.name,
              location: location.location,
              temperature: location.temperature,
              humidity: location.humidity,
              airQuality: location.airQuality,
            ),
          ),
        );
      },
    );
  }
}
