import 'package:flutter/material.dart';

import '../models/industrial_guide.dart';

class IndustrialGuideScreen extends StatefulWidget {
  final List<IndustrialSpot> spots;

  const IndustrialGuideScreen({super.key, required this.spots});

  @override
  State<IndustrialGuideScreen> createState() => _IndustrialGuideScreenState();
}

class _IndustrialGuideScreenState extends State<IndustrialGuideScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Księży Młyn i zabytki industrialne')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Przewodnik po postindustrialnych fabrykach przy Widzewie. Dotknij punkt — opis i trasa spaceru.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB74D)),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.factory_outlined, size: 36),
                    SizedBox(height: 4),
                    Text(
                      'Ilustracja: cegła Księżego Młyna',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final spot in widget.spots)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: Text(spot.title),
                subtitle: Text(
                  _openId == spot.id
                      ? '${spot.era}\n${spot.body}\n${spot.walk}'
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
