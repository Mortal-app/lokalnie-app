import 'package:flutter/material.dart';

import '../models/memorial_guide.dart';

class MemorialGuideScreen extends StatefulWidget {
  final List<MemorialSpot> spots;

  const MemorialGuideScreen({super.key, required this.spots});

  @override
  State<MemorialGuideScreen> createState() => _MemorialGuideScreenState();
}

class _MemorialGuideScreenState extends State<MemorialGuideScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cmentarze i miejsca pamięci')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Historyczne cmentarze i miejsca pamięci narodowej we wschodniej Łodzi. Dotknij, by rozwinąć.',
          ),
          const SizedBox(height: 12),
          for (final spot in widget.spots)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: Text(spot.title),
                subtitle: Text(
                  _openId == spot.id ? '${spot.era}\n${spot.body}' : spot.era,
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
