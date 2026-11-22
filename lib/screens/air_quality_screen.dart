import 'package:flutter/material.dart';

import '../models/air_quality.dart';
import '../models/bike_station.dart';

class AirQualityScreen extends StatelessWidget {
  final List<AirSensorReading> items;

  const AirQualityScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    final alerts = items.where((item) => item.alert).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Jakość powietrza i smog')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Odczyty czujników PM2.5 / PM10 w Twojej okolicy. Alert przy przekroczeniu norm.',
          ),
          if (alerts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFFFFCDD2),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded),
                title: const Text('Alert pyłów'),
                subtitle: Text(
                  alerts
                      .map(
                        (item) =>
                            '${item.name}: PM2.5 ${item.pm25.toStringAsFixed(0)} · PM10 ${item.pm10.toStringAsFixed(0)}',
                      )
                      .join('\n'),
                ),
                isThreeLine: true,
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa czujników',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in items)
                    Align(
                      alignment: _align(item.pos),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.cloud_outlined,
                          color: item.alert
                              ? const Color(0xFFC62828)
                              : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  Icons.air,
                  color: item.alert ? Colors.red : null,
                ),
                title: Text(item.name),
                subtitle: Text(
                  '${item.place}\nPM2.5 ${item.pm25.toStringAsFixed(0)} µg/m³ · PM10 ${item.pm10.toStringAsFixed(0)} µg/m³${item.alert ? ' · przekroczenie' : ''}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
