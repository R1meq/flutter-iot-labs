import 'package:iot_flutter/core/model/location_measurement_data.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<LocationMeasurementData> locations;
  final String mqttStatus;
  final bool isOffline;

  HomeLoaded({
    required this.locations,
    required this.mqttStatus,
    required this.isOffline,
  });

  HomeLoaded copyWith({
    List<LocationMeasurementData>? locations,
    String? mqttStatus,
    bool? isOffline,
  }) {
    return HomeLoaded(
      locations: locations ?? this.locations,
      mqttStatus: mqttStatus ?? this.mqttStatus,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
