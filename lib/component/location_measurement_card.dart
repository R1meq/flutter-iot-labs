import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iot_flutter/component/measurement_card.dart';

// Updated LocationMeasurementCard that generates random values
class LocationMeasurementCard extends StatelessWidget {
  final String name;
  final String location;
  final String? temperature;
  final String? humidity;
  final String? airQuality;

  final Random _random = Random();

  LocationMeasurementCard({
    required this.name,
    required this.location,
    this.temperature,
    this.humidity,
    this.airQuality,
    super.key,
  });

  String _randomTemp() =>
      '${(10 + _random.nextDouble() * 25).toStringAsFixed(1)}°C';
  String _randomHumidity() => '${(30 + _random.nextInt(60))}%';
  String _randomAirQuality() {
    final values = ['Excellent', 'Good', 'Moderate', 'Poor', 'Hazardous'];
    return values[_random.nextInt(values.length)];
  }

  @override
  Widget build(BuildContext context) {
    final temp = temperature ?? _randomTemp();
    final humid = humidity ?? _randomHumidity();
    final air = airQuality ?? _randomAirQuality();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header with name and location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style:
                              Theme.of(context)
                                  .textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            MeasurementCard(
              icon: Icons.thermostat_outlined,
              title: 'Temperature',
              value: temp,
              color: const Color(0xFFD50000),
            ),
            const SizedBox(height: 12),
            MeasurementCard(
              icon: Icons.water_drop,
              title: 'Humidity',
              value: humid,
              color: const Color(0xFF2962FF),
            ),

            const SizedBox(height: 12),
            MeasurementCard(
              icon: Icons.air,
              title: 'Air Quality',
              value: air,
              color: const Color(0xFF00C853),
            ),
          ],
        ),
      ),
    );
  }
}
