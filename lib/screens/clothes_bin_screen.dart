import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/clothes_bin.dart';

class ClothesBinScreen extends StatefulWidget {
  final List<ClothesBinSpot> items;
  final ValueChanged<ClothesBinSpot> onUpdate;

  const ClothesBinScreen({
    super.key,
    required this.items,
    required this.onUpdate,
  });

  @override
  State<ClothesBinScreen> createState() => _ClothesBinScreenState();
}

class _ClothesBinScreenState extends State<ClothesBinScreen> {
  late List<ClothesBinSpot> _items;

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

  void _setIssue(ClothesBinSpot item, ClothesBinIssue issue) {
    final updated = item.copyWith(issue: issue);
    setState(() {
      _items = [
        for (final entry in _items)
          if (entry.id == item.id) updated else entry,
      ];
    });
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontenery na odzież (PCK / Pecet)')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Lokalizacje kontenerów na odzież używaną. Zgłoś zapełnienie lub uszkodzenie pojemnika.',
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
                      'Mapa kontenerów',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final spot in _items)
                    Align(
                      alignment: _align(spot.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.checkroom_outlined,
                          color: Color(0xFF2E7D32),
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
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.checkroom_outlined),
                    title: Text(item.name),
                    subtitle: Text('${item.place}\nStatus: ${item.issue.label}'),
                    isThreeLine: true,
                  ),
                  OverflowBar(
                    children: [
                      TextButton(
                        onPressed: () =>
                            _setIssue(item, ClothesBinIssue.full),
                        child: const Text('Zapełniony'),
                      ),
                      TextButton(
                        onPressed: () =>
                            _setIssue(item, ClothesBinIssue.damaged),
                        child: const Text('Uszkodzony'),
                      ),
                      TextButton(
                        onPressed: () => _setIssue(item, ClothesBinIssue.ok),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
