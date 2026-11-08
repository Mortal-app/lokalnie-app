import 'package:flutter/material.dart';

import '../models/water_filter.dart';

class WaterFilterScreen extends StatefulWidget {
  final List<WaterFilterReminder> items;
  final String userName;
  final ValueChanged<WaterFilterReminder> onAdd;

  const WaterFilterScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WaterFilterScreen> createState() => _WaterFilterScreenState();
}

class _WaterFilterScreenState extends State<WaterFilterScreen> {
  late List<WaterFilterReminder> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WaterFilterReminder>(
      context: context,
      builder: (_) => _FilterDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(WaterFilterReminder item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Przypomnienie: ${item.kind.label} — wymiana ${item.nextChange}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filtry wody')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.water_drop_outlined),
        label: const Text('Wkład'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana wkładów w dzbankach filtrujących i systemach RO pod zlewem.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water_drop_outlined),
                title: Text(item.kind.label),
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

class _FilterDialog extends StatefulWidget {
  final String userName;

  const _FilterDialog({required this.userName});

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  var _kind = WaterFilterKind.pitcher;
  final _next = TextEditingController();

  @override
  void dispose() {
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtr wody'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<WaterFilterKind>(
            initialValue: _kind,
            items: [
              for (final kind in WaterFilterKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
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
              WaterFilterReminder(
                id: 'wf-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                nextChange: _next.text.trim().isEmpty
                    ? 'Za 4 tygodnie'
                    : _next.text.trim(),
                note: 'Zamów wkład z wyprzedzeniem.',
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
