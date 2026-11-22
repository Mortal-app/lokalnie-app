import 'package:flutter/material.dart';

import '../models/widzew_architecture.dart';

class ArchitectureGuideScreen extends StatefulWidget {
  final List<ArchitectureSpot> spots;

  const ArchitectureGuideScreen({super.key, required this.spots});

  @override
  State<ArchitectureGuideScreen> createState() =>
      _ArchitectureGuideScreenState();
}

class _ArchitectureGuideScreenState extends State<ArchitectureGuideScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Architektura i modernizm okolicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Wielka płyta i punkty urbanistyczne osiedla — dotknij, by rozwinąć opis historyczny.',
          ),
          const SizedBox(height: 12),
          for (final spot in widget.spots)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.apartment_outlined),
                title: Text(spot.title),
                subtitle: Text(
                  _openId == spot.id
                      ? '${spot.era}\n${spot.body}'
                      : spot.era,
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
