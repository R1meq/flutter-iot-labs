import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/core/data/location_measurement_storage.dart';
import 'package:iot_flutter/core/model/location_measurement_data.dart';
import 'package:iot_flutter/features/location/cubit/location_editor_state.dart';

class LocationEditorCubit extends Cubit<LocationEditorState> {
  final LocationMeasurementStorage _storage;

  LocationEditorCubit(this._storage) : super(LocationEditorInitial());

  Future<void> saveLocation(LocationMeasurementData updated) async {
    emit(LocationEditorLoading());
    try {
      await _storage.saveMeasurement(updated);
      emit(LocationEditorSuccess());
    } catch (e) {
      emit(LocationEditorError('Failed to save location: $e'));
    }
  }
}
