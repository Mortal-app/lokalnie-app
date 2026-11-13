import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/farm_stall.dart';

class FarmStallScreen extends StatelessWidget {
  final List<FarmStall> items;

  const FarmStallScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warzywa od rolnika')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Bazarki, targowiska i mobilne punkty świeżych warzyw i owoców na Widzewie.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa stoisk',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final stall in items)
                    Align(
                      alignment: _align(stall.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.storefront_outlined,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final stall in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(stall.name),
                subtitle: Text('${stall.whenText}\n${stall.place}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
