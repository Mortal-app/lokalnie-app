import 'package:flutter/material.dart';

import '../models/gas_inspection.dart';

class GasInspectionScreen extends StatefulWidget {
  final List<GasInspection> items;
  final String userName;
  final ValueChanged<GasInspection> onAdd;

  const GasInspectionScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GasInspectionScreen> createState() => _GasInspectionScreenState();
}

class _GasInspectionScreenState extends State<GasInspectionScreen> {
  late List<GasInspection> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GasInspection>(
      context: context,
      builder: (_) => _GasDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(GasInspection item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Przypomnienie: ${item.kind} — ${item.whenText}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Przeglądy gazu i komin')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_fire_department_outlined),
        label: const Text('Termin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Harmonogram wizyt kominiarzy i kontroli szczelności gazu w blokach wielorodzinnych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_fire_department_outlined),
                title: Text('${item.kind} · ${item.block}'),
                subtitle: Text(
                  '${item.whenText}\n${item.note} · ${item.authorName}',
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

class _GasDialog extends StatefulWidget {
  final String userName;

  const _GasDialog({required this.userName});

  @override
  State<_GasDialog> createState() => _GasDialogState();
}

class _GasDialogState extends State<_GasDialog> {
  final _kind = TextEditingController(text: 'Kontrola szczelności gazu');
  final _block = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _kind.dispose();
    _block.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Przegląd'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _kind,
            decoration: const InputDecoration(labelText: 'Rodzaj'),
          ),
          TextField(
            controller: _block,
            decoration: const InputDecoration(labelText: 'Blok / klatka'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
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
              GasInspection(
                id: 'gi-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind.text.trim().isEmpty
                    ? 'Kontrola szczelności gazu'
                    : _kind.text.trim(),
                block: _block.text.trim().isEmpty
                    ? 'Blok osiedlowy'
                    : _block.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do ogłoszenia administracji'
                    : _when.text.trim(),
                note: 'Udostępnij kuchnię i kratki wentylacyjne.',
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
