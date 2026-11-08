import 'package:flutter/material.dart';

import '../models/garden_tool_care.dart';

class GardenToolCareScreen extends StatefulWidget {
  final List<GardenToolCareOffer> items;
  final String userName;
  final ValueChanged<GardenToolCareOffer> onAdd;

  const GardenToolCareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GardenToolCareScreen> createState() => _GardenToolCareScreenState();
}

class _GardenToolCareScreenState extends State<GardenToolCareScreen> {
  late List<GardenToolCareOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GardenToolCareOffer>(
      context: context,
      builder: (_) => _ToolDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renowacja narzędzi ogrodowych')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.hardware_outlined),
        label: const Text('Oferuję ostrzenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Ostrzenie sekatorów, nożyc do żywopłotu i konserwacja kosiarek przed sezonem.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.hardware_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolDialog extends StatefulWidget {
  final String userName;

  const _ToolDialog({required this.userName});

  @override
  State<_ToolDialog> createState() => _ToolDialogState();
}

class _ToolDialogState extends State<_ToolDialog> {
  var _kind = GardenToolKind.pruner;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Narzędzie ogrodowe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<GardenToolKind>(
            initialValue: _kind,
            items: [
              for (final kind in GardenToolKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Ogłoszenie'),
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
              GardenToolCareOffer(
                id: 'gt-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Ostrzenie przed sezonem'
                    : _title.text.trim(),
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
