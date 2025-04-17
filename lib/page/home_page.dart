import 'package:flutter/material.dart';
import 'package:iot_flutter/component/location_measurement_card.dart';
import 'package:iot_flutter/constants/app_colors.dart';
import 'package:iot_flutter/data/location_measurement_storage.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/model/location_measurement_data.dart';
import 'package:iot_flutter/page/location_editor_page.dart';
import 'package:iot_flutter/page/profile_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = LocationMeasurementStorage();
  List<LocationMeasurementData> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await _storage.getUserMeasurement();
      setState(() => _locations = locations);
    } catch (e) {
      _showError('Failed to load locations: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _addLocation() async {
    final userId = UserStorage.loggedUser?.id ?? 'anonymous';
    const uuid = Uuid();

    final newLocation = LocationMeasurementData(
      id: uuid.v4(),
      userId: userId,
      name: 'New Location',
      location: 'Location Address',
    );

    try {
      setState(() {
        _locations.add(newLocation);
      });
      await _storage.saveMeasurement(newLocation);
      await _loadLocations();
    } catch (e) {
      await _loadLocations();
      _showError('Failed to add location: $e');
    }
  }

  Future<void> _deleteLocation(String id) async {
    try {
      setState(() {
        _locations.removeWhere((location) => location.id == id);
      });
      await _storage.deleteMeasurement(id);
    } catch (e) {
      await _loadLocations();
      _showError('Failed to delete location: $e');
    }
  }

  Future<void> _editLocation(LocationMeasurementData location) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LocationEditorPage(location: location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Locations',
            style: Theme.of(context).textTheme.titleLarge, ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>
                  (builder: (context) => const ProfilePage(), ),
              );
            },
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: _addLocation,
            tooltip: 'Add Location',
          ),
        ],
      ),
      body: _locations.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          final location = _locations[index];
          return Dismissible(
            key: Key(location.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _deleteLocation(location.id),
            child: GestureDetector(
              onTap: () => _editLocation(location),
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
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No locations yet',
              style: Theme.of(context).textTheme.titleMedium, ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Location'),
            onPressed: _addLocation,
          ),
        ],
      ),
    );
  }
}
