import 'package:flutter/material.dart';

import '../models/bike_station.dart';

class BikeStationsScreen extends StatefulWidget {
  final List<BikeRepairStation> items;
  final void Function(String id, {bool? toolsOk, bool? pumpOk}) onStatus;

  const BikeStationsScreen({
    super.key,
    required this.items,
    required this.onStatus,
  });

  @override
  State<BikeStationsScreen> createState() => _BikeStationsScreenState();
}

class _BikeStationsScreenState extends State<BikeStationsScreen> {
  late List<BikeRepairStation> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  void _toggleTools(BikeRepairStation item) {
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(toolsOk: !entry.toolsOk) : entry,
          )
          .toList();
    });
    widget.onStatus(item.id, toolsOk: !item.toolsOk);
  }

  void _togglePump(BikeRepairStation item) {
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(pumpOk: !entry.pumpOk) : entry,
          )
          .toList();
    });
    widget.onStatus(item.id, pumpOk: !item.pumpOk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stacje napraw rowerów')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Ogólnodostępne stacje: narzędzia i pompki stacjonarne na Widzewie.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
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
                      'Mapa stacji',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pedal_bike,
                              color: item.pumpOk && item.toolsOk
                                  ? const Color(0xFF1565C0)
                                  : Colors.orange,
                            ),
                            Text(
                              item.name,
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
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.place}\nNarzędzia: ${item.toolsOk ? 'OK' : 'brak'} · Pompka: ${item.pumpOk ? 'OK' : 'brak'}',
                      ),
                      isThreeLine: true,
                    ),
                    OverflowBar(
                      children: [
                        TextButton(
                          onPressed: () => _toggleTools(item),
                          child: const Text('Narzędzia'),
                        ),
                        TextButton(
                          onPressed: () => _togglePump(item),
                          child: const Text('Pompka'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
