import 'package:flutter/material.dart';

import '../models/district_activity.dart';

class DistrictReportScreen extends StatelessWidget {
  final int activeStaircases;
  final List<String> staircaseNames;
  final int completedInitiatives;
  final List<BlockRanking> ranking;

  const DistrictReportScreen({
    super.key,
    required this.activeStaircases,
    required this.staircaseNames,
    required this.completedInitiatives,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...ranking]..sort((a, b) => b.score.compareTo(a.score));
    return Scaffold(
      appBar: AppBar(title: const Text('Raport aktywności dzielnicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.apartment_outlined),
              title: const Text('Aktywne klatki'),
              subtitle: Text(
                staircaseNames.isEmpty
                    ? 'Brak zgłoszonych klatek w tym tygodniu'
                    : staircaseNames.join(', '),
              ),
              trailing: Text(
                '$activeStaircases',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Zrealizowane inicjatywy społeczne'),
              subtitle: const Text(
                'Petycje, zbiórki i projekty z budżetu obywatelskiego',
              ),
              trailing: Text(
                '$completedInitiatives',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ranking zaangażowania bloków',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < sorted.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(sorted[i].blockName),
                subtitle: Text(
                  'Aktywne klatki w bloku: ${sorted[i].activeStaircases}',
                ),
                trailing: Text('${sorted[i].score} pkt'),
              ),
            ),
        ],
      ),
    );
  }
}
