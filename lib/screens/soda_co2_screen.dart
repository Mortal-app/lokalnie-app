import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/soda_co2.dart';

class SodaCo2Screen extends StatelessWidget {
  final List<SodaCo2Spot> items;

  const SodaCo2Screen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wymiana butli SodaStream / CO2')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Punkty nabijania i wymiany różowych oraz niebieskich cylindrów CO2 do syfonów i saturatorów na Widzewie.',
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
                      'Mapa wymiany CO2',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final spot in items)
                    Align(
                      alignment: _align(spot.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.local_drink_outlined,
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
                leading: const Icon(Icons.local_drink_outlined),
                title: Text(item.name),
                subtitle: Text('${item.place}\n${item.cylinder.label}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
