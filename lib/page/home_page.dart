import 'package:flutter/material.dart';
import 'package:iot_flutter/component/measurement_card.dart';
import 'package:iot_flutter/constants/app_colors.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const pressure = '1013 hPa';
    const temperature = '22°C';
    const airQuality = 'Good';

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',
            style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Current Measurements',
                style: Theme.of(context).textTheme.titleLarge, ),
            const MeasurementCard(
              title: 'Pressure',
              value: pressure,
              icon: Icons.speed,
              color: AppColors.pressure,
            ),
            const MeasurementCard(
              title: 'Temperature',
              value: temperature,
              icon: Icons.thermostat_outlined,
              color: AppColors.temperature,
            ),
            const MeasurementCard(
              title: 'Air Quality',
              value: airQuality,
              icon: Icons.air,
              color: AppColors.airQuality,
            ),
          ],
        ),
      ),
    );
  }
}
