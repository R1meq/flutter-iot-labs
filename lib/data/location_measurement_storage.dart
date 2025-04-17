import 'dart:convert';

import 'package:iot_flutter/data/i_location_measurement_storage.dart';
import 'package:iot_flutter/data/user_storage.dart';
import 'package:iot_flutter/model/location_measurement_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationMeasurementStorage implements ILocationMeasurementStorage {
  static const String _locationMeasurementKey = 'location_measurement_data';

  @override
  Future<void> deleteMeasurement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getAllMeasurement();
    final updatedList = currentList.where((item) => item.id != id).toList();
    final encoded = jsonEncode(updatedList.map((e) => e.toJson()).toList());
    await prefs.setString(_locationMeasurementKey, encoded);
  }

  @override
  Future<List<LocationMeasurementData>> getAllMeasurement() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_locationMeasurementKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => LocationMeasurementData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LocationMeasurementData>> getUserMeasurement() async {
    final data = await getAllMeasurement();
    return data
        .where((e) => e.userId == UserStorage.loggedUser?.id)
        .toList();
  }

  @override
  Future<void> saveMeasurement(LocationMeasurementData measurement) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getAllMeasurement();
    final existingIndex = currentList
        .indexWhere((item) => item.id == measurement.id);

    if (existingIndex >= 0) {
      currentList[existingIndex] = measurement;
    } else {
      currentList.add(measurement);
    }

    final encoded = jsonEncode(currentList.map((e) => e.toJson()).toList());
    await prefs.setString(_locationMeasurementKey, encoded);
  }

}
