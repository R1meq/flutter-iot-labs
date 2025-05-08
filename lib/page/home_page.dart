import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iot_flutter/component/location_measurement_card.dart';
import 'package:iot_flutter/constants/app_colors.dart';
import 'package:iot_flutter/data/location_measurement_storage.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/model/location_measurement_data.dart';
import 'package:iot_flutter/model/mqtt_handler.dart';
import 'package:iot_flutter/page/location_editor_page.dart';
import 'package:iot_flutter/page/profile_page.dart';
import 'package:iot_flutter/utils/network_monitor.dart';
import 'package:iot_flutter/utils/sensor_formatter.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _logger = Logger();
  final _storage = LocationMeasurementStorage();
  List<LocationMeasurementData> _locations = [];
  late MqttHandler _mqttHandler;
  String _mqttStatus = 'Disconnected';
  bool _isActive = false;
  bool isOffline = false;
  Timer? _networkCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeMqttHandler();
    _startNetworkMonitor();
    _loadLocations();
  }

  void _initializeMqttHandler() {
    _mqttHandler = MqttHandler();

    _mqttHandler.statusNotifier.addListener(() {
      if (!mounted) return;
      setState(() {
        _mqttStatus = _mqttHandler.statusNotifier.value;
      });
    });

    _isActive = true;
  }

  Future<void> _connectToMqtt() async {
    if (_mqttStatus != 'Connected') {
      _logger.i('Connecting to MQTT broker...');
      await _mqttHandler.connect();

      if (_mqttStatus == 'Connected') {
        _mqttHandler.subscribe('sensor/temperature');
        _mqttHandler.subscribe('sensor/humidity');
        _mqttHandler.subscribe('sensor/airQuality');
        _mqttHandler.listenForMessages(_handleMqttMessage);
        _logger.i('Successfully connected to MQTT and subscribed to topics');
      }
    } else {
      _logger.i('Already connected to MQTT broker');
    }
  }

  void _handleMqttMessage(Map<String, dynamic> message) {
    if (!_isActive || _locations.isEmpty) {
      return;
    }

    if (message.containsKey('timestamp') &&
        message.containsKey('value') &&
        message.containsKey('sensorType')) {
      final String sensorType = message['sensorType'].toString();
      final dynamic rawValue = message['value'];
      final String formattedValue = SensorFormatter
          .formatSensorValue(sensorType, rawValue);

      setState(() {
        _locations = _locations.map((location) {
          switch (sensorType) {
            case 'temperature':
              return location.copyWith(temperature: formattedValue);
            case 'humidity':
              return location.copyWith(humidity: formattedValue);
            case 'airQuality':
              return location.copyWith(airQuality: formattedValue);
            default:
              _logger.w('Unknown sensor type: $sensorType');
              return location;
          }
        }).toList();
      });
      _saveUpdatedLocations();
    }
  }

  Future<void> _saveUpdatedLocations() async {
    try {
      for (var location in _locations) {
        await _storage.saveMeasurement(location);
      }
    } catch (e) {
      _showError('Failed to save updated locations: $e');
    }
  }

  @override
  void dispose() {
    _isActive = false;
    _disconnectFromMqtt();
    _networkCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await _storage.getUserMeasurement();
      if (mounted) {
        setState(() => _locations = locations);
      }
      _manageMqttConnection();
    } catch (e) {
      _showError('Failed to load locations: $e');
    }
  }

  void _manageMqttConnection() {
    if (_isActive) {
      if (_locations.isNotEmpty) {
        _connectToMqtt();
      } else if (_mqttStatus == 'Connected') {
        _disconnectFromMqtt();
      }
    }
  }

  void _disconnectFromMqtt() {
    if (_mqttStatus == 'Connected') {
      _mqttHandler.disconnect();
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
      await _storage.saveMeasurement(newLocation);
      await _loadLocations();
    } catch (e) {
      _showError('Failed to add location: $e');
      await _loadLocations();
    }
  }

  Future<void> _deleteLocation(String id) async {
    try {
      await _storage.deleteMeasurement(id);
      await _loadLocations();
    } catch (e) {
      _showError('Failed to delete location: $e');
      await _loadLocations();
    }
  }

  Future<void> _editLocation(LocationMeasurementData location) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => LocationEditorPage(location: location),
      ),
    );

    if (result == true) {
      await _loadLocations();
    }
  }

  void _startNetworkMonitor() {
    _networkCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final hasConnection = await NetworkMonitor.checkConnection();
      if (hasConnection != !isOffline) {
        setState(() => isOffline = !hasConnection);
        if (!mounted) return;
        if (!hasConnection) {
          _showNetworkSnackBar('You are offline');
        } else {
          _showNetworkSnackBar('Back online');
        }
      }
    });
  }

  void _showNetworkSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
          Chip(
            label: Text('MQTT: $_mqttStatus'),
            backgroundColor: _mqttStatus == 'Connected'
                ? Colors.green.shade100
                : Colors.red.shade100,
          ),
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
