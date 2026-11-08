import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/scooter_hub.dart';

class ScooterHubScreen extends StatelessWidget {
  final List<ScooterHub> items;

  const ScooterHubScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hulajnogi miejskie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Schemat najpopularniejszych stojaków i stacji hulajnóg elektrycznych na Widzewie.',
          ),
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
                      'Mapa stojaków hulajnóg',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final hub in items)
                    Align(
                      alignment: _align(hub.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.two_wheeler,
                          color: Color(0xFF2E7D32),
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
                leading: const Icon(Icons.two_wheeler),
                title: Text(hub.name),
                subtitle: Text('${hub.place}\n${hub.operatorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
