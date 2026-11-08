import 'package:flutter/material.dart';

import '../models/street_archive.dart';

class StreetArchiveScreen extends StatefulWidget {
  final List<StreetArchiveEntry> entries;

  const StreetArchiveScreen({super.key, required this.entries});

  @override
  State<StreetArchiveScreen> createState() => _StreetArchiveScreenState();
}

class _StreetArchiveScreenState extends State<StreetArchiveScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne nazwy ulic')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Historyczne nazwy ulic i ewolucja patronów od czasów przedwojennych.',
          ),
          const SizedBox(height: 12),
          for (final entry in widget.entries)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.history_edu_outlined),
                title: Text(entry.currentName),
                subtitle: Text(
                  _openId == entry.id
                      ? 'Dawniej: ${entry.formerName}\n${entry.era}\n${entry.body}'
                      : 'Dawniej: ${entry.formerName} · ${entry.era}',
                ),
                isThreeLine: _openId == entry.id,
                onTap: () => setState(
                  () => _openId = _openId == entry.id ? null : entry.id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
