import 'package:flutter/material.dart';

import '../models/neighbor_hub.dart';

class NeighborHubScreen extends StatefulWidget {
  final Map<String, VoidCallback> openers;

  const NeighborHubScreen({super.key, required this.openers});

  @override
  State<NeighborHubScreen> createState() => _NeighborHubScreenState();
}

class _NeighborHubScreenState extends State<NeighborHubScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.text.trim();
    final visible = NeighborHubCatalog.entries
        .where((entry) => entry.matches(query))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Centrum Sąsiedzkie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Najważniejsze usługi osiedla. Wpisz frazę, np. olej, chleb, rolety.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _query,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Szukaj modułu…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Wyczyść',
                      onPressed: () {
                        _query.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(child: Text('Brak modułów dla tej frazy.')),
            ),
          for (final category in NeighborHubCategory.values)
            ..._section(category, visible),
        ],
      ),
    );
  }

  List<Widget> _section(
    NeighborHubCategory category,
    List<NeighborHubEntry> visible,
  ) {
    final items = visible
        .where((entry) => entry.category == category)
        .take(3)
        .toList();
    if (items.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
        child: Row(
          children: [
            Icon(category.icon, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category.label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      for (final item in items)
          Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: Icon(category.icon),
            title: Text(item.title, softWrap: true),
            trailing: const Icon(Icons.chevron_right),
            onTap: widget.openers[item.id],
          ),
        ),
    ];
  }
}
