import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/ewaste_point.dart';

class EwasteMapScreen extends StatelessWidget {
  final List<EwastePoint> items;

  const EwasteMapScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eko-punkty i elektrośmieci')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Baterie, elektroodpady i małe AGD — markety i spółdzielnie na Widzewie.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF90CAF9)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa eko-punktów',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.battery_charging_full,
                          color: Color(0xFF1565C0),
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
                leading: const Icon(Icons.electrical_services_outlined),
                title: Text(item.name),
                subtitle: Text('${item.kind.label} · ${item.place}'),
              ),
            ),
        ],
      ),
    );
  }
}
