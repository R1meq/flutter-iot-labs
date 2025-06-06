import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/data/location_measurement_storage.dart';
import 'package:iot_flutter/core/data/user_storage.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/core/utils/mqtt_handler.dart';
import 'package:iot_flutter/core/utils/network_monitor.dart';
import 'package:iot_flutter/core/utils/sensor_formatter.dart';
import 'package:iot_flutter/features/home/cubit/home_state.dart';
import 'package:uuid/uuid.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationMeasurementStorage _storage;
  final MqttHandler _mqttHandler;
  Timer? _networkCheckTimer;
  bool _isActive = true;

  HomeCubit(this._storage, this._mqttHandler) : super(HomeInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    _mqttHandler.statusNotifier.addListener(_onMqttStatusChanged);
    _startNetworkMonitor();
    await loadLocations();
  }

  void _onMqttStatusChanged() {
    final status = _mqttHandler.statusNotifier.value;
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(mqttStatus: status));
    }
  }

  Future<void> loadLocations() async {
    emit(HomeLoading());
    try {
      final locations = await _storage.getUserMeasurement();
      final status = _mqttHandler.statusNotifier.value;
      emit(HomeLoaded(
        locations: locations,
        mqttStatus: status,
        isOffline: false,
      ),);
      _manageMqttConnection(locations);
    } catch (e) {
      emit(HomeError('Failed to load locations: $e'));
    }
  }

  void _manageMqttConnection(List<LocationMeasurementData> locations) {
    if (_isActive) {
      if (locations.isNotEmpty) {
        _connectToMqtt();
      } else if (_mqttHandler.statusNotifier.value == 'Connected') {
        _disconnectFromMqtt();
      }
    }
  }

  Future<void> _connectToMqtt() async {
    final status = _mqttHandler.statusNotifier.value;
    if (status != 'Connected') {
      await _mqttHandler.connect();

      if (_mqttHandler.statusNotifier.value == 'Connected') {
        _mqttHandler.subscribe('sensor/temperature');
        _mqttHandler.subscribe('sensor/humidity');
        _mqttHandler.subscribe('sensor/airQuality');
        _mqttHandler.listenForMessages(_handleMqttMessage);
      }
    }
  }

  void _disconnectFromMqtt() {
    if (_mqttHandler.statusNotifier.value == 'Connected') {
      _mqttHandler.disconnect();
    }
  }

  void _handleMqttMessage(Map<String, dynamic> message) async {
    if (!_isActive || state is! HomeLoaded) return;
    final current = state as HomeLoaded;

    if (message.containsKey('timestamp') &&
        message.containsKey('value') &&
        message.containsKey('sensorType')) {
      final sensorType = message['sensorType'].toString();
      final rawValue = message['value'];
      final formattedValue = SensorFormatter
          .formatSensorValue(sensorType, rawValue);
      final updatedLocations = current.locations.map((location) {
        switch (sensorType) {
          case 'temperature':
            return location.copyWith(temperature: formattedValue);
          case 'humidity':
            return location.copyWith(humidity: formattedValue);
          case 'airQuality':
            return location.copyWith(airQuality: formattedValue);
          default:
            return location;
        }
      }).toList();
      emit(current.copyWith(locations: updatedLocations));
      _saveUpdatedLocations(updatedLocations);
    }
  }

  Future<void> _saveUpdatedLocations(
      List<LocationMeasurementData> locations,) async {
    try {
      for (var location in locations) {
        await _storage.saveMeasurement(location);
      }
    } catch (e) {
      emit(HomeError('Failed to save updated locations: $e'));
    }
  }

  Future<void> addLocation() async {
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
      await loadLocations();
    } catch (e) {
      emit(HomeError('Failed to add location: $e'));
    }
  }

  Future<void> deleteLocation(String id) async {
    try {
      await _storage.deleteMeasurement(id);
      await loadLocations();
    } catch (e) {
      emit(HomeError('Failed to delete location: $e'));
    }
  }

  void _startNetworkMonitor() {
    _networkCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final hasConnection = await NetworkMonitor.checkConnection();
      if (state is HomeLoaded) {
        final current = state as HomeLoaded;
        final newOfflineState = !hasConnection;

        if (current.isOffline != newOfflineState) {
          emit(current.copyWith(isOffline: newOfflineState));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _isActive = false;
    _disconnectFromMqtt();
    _networkCheckTimer?.cancel();
    return super.close();
  }
}
