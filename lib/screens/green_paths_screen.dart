import 'package:flutter/material.dart';

import '../models/green_path.dart';

class GreenPathsScreen extends StatefulWidget {
  final List<GreenPathSpot> spots;

  const GreenPathsScreen({super.key, required this.spots});

  @override
  State<GreenPathsScreen> createState() => _GreenPathsScreenState();
}

class _GreenPathsScreenState extends State<GreenPathsScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zielone ścieżki i rezerwaty')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Mniej znane zakątki przyrodnicze wschodniej Łodzi — dotknij, by rozwinąć opis.',
          ),
          const SizedBox(height: 12),
          for (final spot in widget.spots)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.park_outlined),
                title: Text(spot.title),
                subtitle: Text(
                  _openId == spot.id
                      ? '${spot.area}\n${spot.body}'
                      : spot.area,
                ),
                isThreeLine: _openId == spot.id,
                onTap: () => setState(
                  () => _openId = _openId == spot.id ? null : spot.id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
