import 'package:iot_flutter/core/model/location_measurement_data.dart';

abstract class ILocationMeasurementStorage {
  Future<void> saveMeasurement(LocationMeasurementData card);
  Future<List<LocationMeasurementData>> getUserMeasurement();
  Future<List<LocationMeasurementData>> getAllMeasurement();
  Future<void> deleteMeasurement(String id);
}
