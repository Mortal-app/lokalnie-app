import 'package:flutter/material.dart';

import '../models/jasien_guide.dart';

class JasienGuideScreen extends StatelessWidget {
  final List<JasienSpot> spots;

  const JasienGuideScreen({super.key, required this.spots});

  Alignment _align(AlignmentPos pos) => switch (pos) {
    AlignmentPos.topLeft => Alignment.topLeft,
    AlignmentPos.center => Alignment.center,
    AlignmentPos.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Park nad rzeką')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Mini-przewodnik po lokalnej zieleni: ścieżki rowerowe i miejsca wypoczynku.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFC8E6C9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF81C784)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapka ścieżek zieleni',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final spot in spots)
                    Align(
                      alignment: _align(spot.pos),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              spot.kind.contains('rower')
                                  ? Icons.pedal_bike_outlined
                                  : Icons.park_outlined,
                              color: const Color(0xFF2E7D32),
                            ),
                            Text(
                              spot.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final spot in spots)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  spot.kind.contains('rower')
                      ? Icons.directions_bike_outlined
                      : Icons.weekend_outlined,
                ),
                title: Text(spot.name),
                subtitle: Text('${spot.kind}\n${spot.hint}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
