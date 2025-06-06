import 'package:get_it/get_it.dart';
import 'package:iot_flutter/core/data/location_measurement_storage.dart';
import 'package:iot_flutter/core/data/user_storage.dart';
import 'package:iot_flutter/core/utils/app_startup_service.dart';
import 'package:iot_flutter/core/utils/mqtt_handler.dart';
import 'package:iot_flutter/core/utils/usb_serial_service.dart';
import 'package:iot_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:iot_flutter/features/home/cubit/home_cubit.dart';
import 'package:iot_flutter/features/location/cubit/location_editor_cubit.dart';
import 'package:iot_flutter/features/message/cubit/device_message_cubit.dart';
import 'package:iot_flutter/features/profile/cubit/profile_cubit.dart';
import 'package:iot_flutter/features/qr_scanner/cubit/qr_scanner_cubit.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<Logger>(Logger.new);

  getIt.registerLazySingleton<UserStorage>(UserStorage.new);
  getIt.registerLazySingleton<LocationMeasurementStorage>
    (LocationMeasurementStorage.new,);
  getIt.registerLazySingleton<UsbSerialService>(UsbSerialService.new,);
  getIt.registerLazySingleton(() =>
      AppStartupService(userStorage: getIt<UserStorage>()),);

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<UserStorage>()),);
  getIt.registerFactory(() => DeviceMessageCubit(getIt<UsbSerialService>()),);
  getIt.registerFactory(() => ProfileCubit(getIt<UserStorage>()),);
  getIt.registerFactory(() => QRScannerCubit(getIt<UsbSerialService>()),);
  getIt.registerFactory<HomeCubit>(() =>
      HomeCubit(getIt<LocationMeasurementStorage>(), getIt<MqttHandler>(),),);
  getIt.registerFactory(() =>
      LocationEditorCubit(getIt<LocationMeasurementStorage>()),);

  getIt.registerLazySingleton<MqttServerClient>(createMqttClient);
  getIt.registerLazySingleton<MqttHandler>(() =>
      MqttHandler(getIt<MqttServerClient>(), getIt<Logger>(),),);
}


MqttServerClient createMqttClient() {
  return MqttServerClient(
    'broker.hivemq.com',
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  );
}
