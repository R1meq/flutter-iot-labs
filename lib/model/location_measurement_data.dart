import 'dart:math';

class LocationMeasurementData {
  final String id;
  final String userId;
  final String name;
  final String location;
  final String temperature;
  final String humidity;
  final String airQuality;

  LocationMeasurementData({
    required this.id,
    required this.userId,
    required this.name,
    required this.location,
    String? temperature,
    String? humidity,
    String? airQuality,
  }) :
        temperature = temperature ?? _generateRandomTemperature(),
        humidity = humidity ?? _generateRandomHumidity(),
        airQuality = airQuality ?? _generateRandomAirQuality();

  static String _generateRandomTemperature() {
    final random = Random();
    return '${(10 + random.nextDouble() * 25).toStringAsFixed(1)}°C';
  }

  static String _generateRandomHumidity() {
    final random = Random();
    return '${(30 + random.nextInt(60))}%';
  }

  static String _generateRandomAirQuality() {
    final random = Random();
    final airQualityValues = [
      'Excellent',
      'Good',
      'Moderate',
      'Poor',
      'Hazardous',
    ];
    return airQualityValues[random.nextInt(airQualityValues.length)];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'location': location,
      'temperature': temperature,
      'humidity': humidity,
      'airQuality': airQuality,
    };
  }

  factory LocationMeasurementData.fromJson(Map<String, dynamic> json) {
    return LocationMeasurementData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      temperature: json['temperature'] as String,
      humidity: json['humidity'] as String,
      airQuality: json['airQuality'] as String,
    );
  }
}
