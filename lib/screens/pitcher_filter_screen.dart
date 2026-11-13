import 'package:flutter/material.dart';

import '../models/pitcher_filter.dart';
import '../theme/widzew_ui.dart';

class PitcherFilterScreen extends StatefulWidget {
  final List<PitcherFilterLog> items;
  final String userName;
  final ValueChanged<PitcherFilterLog> onAdd;
  final ValueChanged<PitcherFilterLog> onReset;

  const PitcherFilterScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onReset,
  });

  @override
  State<PitcherFilterScreen> createState() => _PitcherFilterScreenState();
}

class _PitcherFilterScreenState extends State<PitcherFilterScreen> {
  late List<PitcherFilterLog> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PitcherFilterLog>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PitcherDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _reset(PitcherFilterLog item) {
    final reset = PitcherFilterLog(
      id: item.id,
      brand: item.brand,
      daysSinceChange: 0,
      note: item.note,
      authorName: item.authorName,
    );
    setState(() {
      _items = [
        for (final entry in _items)
          if (entry.id == item.id) reset else entry,
      ];
    });
    widget.onReset(reset);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wkład oznaczony jako wymieniony.')),
    );
  }

  void _remind() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Przypomnienie: wymień wkład w dzbanku.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtr dzbanka do wody'),
        actions: [
          IconButton(
            tooltip: 'Przypomnij o wkładzie',
            onPressed: _remind,
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text('Dzbanek'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Licznik dni od ostatniej wymiany wkładu w dzbanku filtrującym do wody pitnej.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.filter_alt_outlined),
                title: Text(item.brand),
                subtitle: Text(
                  '${item.daysSinceChange} dni od wymiany\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => _reset(item),
                  child: const Text('Wymieniony'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PitcherDialog extends StatefulWidget {
  final String userName;

  const _PitcherDialog({required this.userName});

  @override
  State<_PitcherDialog> createState() => _PitcherDialogState();
}

class _PitcherDialogState extends State<_PitcherDialog> {
  final _brand = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _brand.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowy dzbanek'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _brand,
            decoration: const InputDecoration(labelText: 'Nazwa'),
          ),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Notatka'),
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
              PitcherFilterLog(
                id: 'pf-${DateTime.now().millisecondsSinceEpoch}',
                brand: _brand.text.trim().isEmpty
                    ? 'Dzbanek filtrujący'
                    : _brand.text.trim(),
                daysSinceChange: 0,
                note: _note.text.trim(),
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
