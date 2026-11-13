import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/phone_charge.dart';

class PhoneChargeScreen extends StatelessWidget {
  final List<PhoneChargeHub> items;

  const PhoneChargeScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ładowanie telefonu')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Punkty awaryjnego podładowania smartfona — biblioteki, domy kultury i przestrzeń publiczna Widzewa.',
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
                      'Mapa gniazdek i powerbanków',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final hub in items)
                    Align(
                      alignment: _align(hub.pos),
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
          for (final hub in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.battery_charging_full),
                title: Text(hub.name),
                subtitle: Text('${hub.place}\n${hub.note}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
