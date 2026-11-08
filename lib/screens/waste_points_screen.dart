import 'package:flutter/material.dart';

import '../models/waste_point.dart';

class WastePointsScreen extends StatefulWidget {
  const WastePointsScreen({super.key});

  @override
  State<WastePointsScreen> createState() => _WastePointsScreenState();
}

class _WastePointsScreenState extends State<WastePointsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final points = WastePoint.points.where((point) {
      if (_query.trim().isEmpty) return true;
      final haystack =
          '${point.name} ${point.kind} ${point.address} ${point.details}'
              .toLowerCase();
      return haystack.contains(_query.trim().toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Elektrośmieci i PSZOK')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Szukaj punktu zbiórki',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: points.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final point = points[index];
                return Card(
                  child: ListTile(
                    leading: Icon(switch (point.kind) {
                      'PSZOK' => Icons.factory_outlined,
                      'Elektrośmieci' => Icons.electrical_services_outlined,
                      _ => Icons.weekend_outlined,
                    }),
                    title: Text(point.name),
                    subtitle: Text(
                      '${point.kind} · ${point.address}\n'
                      '${point.hours}\n${point.details}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
