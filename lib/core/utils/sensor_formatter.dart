class SensorFormatter {
  static String formatSensorValue(String sensorType, dynamic rawValue) {
    switch (sensorType) {
      case 'temperature':
        final value = rawValue is num ? rawValue.toDouble()
            : double.tryParse(rawValue.toString()) ?? 20.0;
        return '${value.toStringAsFixed(1)}°C';
      case 'humidity':
        final value = rawValue is num ? rawValue.round()
            : int.tryParse(rawValue.toString()) ?? 50;
        return '$value%';
      case 'airQuality':
        final value = rawValue is num ? rawValue.round()
            : int.tryParse(rawValue.toString()) ?? 100;
        if (value < 50) return 'Excellent';
        if (value < 100) return 'Good';
        if (value < 150) return 'Moderate';
        if (value < 200) return 'Poor';
        return 'Hazardous';
      default:
        return rawValue.toString();
    }
  }
}
