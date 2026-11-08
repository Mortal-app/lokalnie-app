import 'package:flutter/material.dart';

import '../models/industry_memory.dart';

class IndustryMemoryScreen extends StatefulWidget {
  final List<IndustryMemory> entries;

  const IndustryMemoryScreen({super.key, required this.entries});

  @override
  State<IndustryMemoryScreen> createState() => _IndustryMemoryScreenState();
}

class _IndustryMemoryScreenState extends State<IndustryMemoryScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WiMa, Stomil i zakłady')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Dawne potęgi przemysłowe Łodzi, które dawały pracę mieszkańcom Widzewa.',
          ),
          const SizedBox(height: 12),
          for (final entry in widget.entries)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.factory_outlined),
                title: Text(entry.title),
                subtitle: Text(
                  _openId == entry.id
                      ? '${entry.era}\n${entry.body}'
                      : entry.era,
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
