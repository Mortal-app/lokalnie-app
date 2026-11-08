import 'package:flutter/material.dart';

import '../models/hepa_tracker.dart';

class HepaTrackerScreen extends StatefulWidget {
  final List<HepaTracker> items;
  final String userName;
  final ValueChanged<HepaTracker> onAdd;

  const HepaTrackerScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<HepaTrackerScreen> createState() => _HepaTrackerScreenState();
}

class _HepaTrackerScreenState extends State<HepaTrackerScreen> {
  late List<HepaTracker> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<HepaTracker>(
      context: context,
      builder: (_) => _HepaDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(HepaTracker item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filtr HEPA: ${item.device} — wymiana ${item.nextChange}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oczyszczacze i filtry HEPA')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.air_outlined),
        label: const Text('Urządzenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Zużycie filtrów HEPA w domu — przypomnienie o zakupie lub czyszczeniu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.air_outlined),
                title: Text(item.device),
                subtitle: Text(
                  '${item.nextChange}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Przypomnij',
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _remind(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HepaDialog extends StatefulWidget {
  final String userName;

  const _HepaDialog({required this.userName});

  @override
  State<_HepaDialog> createState() => _HepaDialogState();
}

class _HepaDialogState extends State<_HepaDialog> {
  final _device = TextEditingController();
  final _next = TextEditingController();

  @override
  void dispose() {
    _device.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtr HEPA'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _device,
            decoration: const InputDecoration(labelText: 'Urządzenie'),
          ),
          TextField(
            controller: _next,
            decoration: const InputDecoration(labelText: 'Następna wymiana'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              HepaTracker(
                id: 'hepa-${DateTime.now().millisecondsSinceEpoch}',
                device: _device.text.trim().isEmpty
                    ? 'Oczyszczacz powietrza'
                    : _device.text.trim(),
                nextChange: _next.text.trim().isEmpty
                    ? 'Za 3 miesiące'
                    : _next.text.trim(),
                note: 'Sprawdź filtr i zamów zamiennik.',
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
