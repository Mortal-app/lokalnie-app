import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/pram_access.dart';

class PramAccessScreen extends StatelessWidget {
  final List<PramAccessSpot> items;

  const PramAccessScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wózki — podjazdy i windy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Podjazdy, windy bez barier i miejsca przyjazne rodzicom z wózkami w budynkach użyteczności publicznej.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF9FA8DA)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa dostępności z wózkiem',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final spot in items)
                    Align(
                      alignment: _align(spot.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.accessible,
                          color: Color(0xFF3949AB),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final spot in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.accessible),
                title: Text(spot.name),
                subtitle: Text('${spot.place}\n${spot.note}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
