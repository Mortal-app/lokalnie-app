import 'package:flutter/material.dart';

import '../models/solar_share.dart';
import '../theme/widzew_ui.dart';

class SolarShareScreen extends StatefulWidget {
  final List<SolarSharePost> items;
  final String userName;
  final ValueChanged<SolarSharePost> onAdd;

  const SolarShareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SolarShareScreen> createState() => _SolarShareScreenState();
}

class _SolarShareScreenState extends State<SolarShareScreen> {
  late List<SolarSharePost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SolarSharePost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SolarDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giełda solarna')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.wb_sunny_outlined),
        label: const Text('Wpis PV'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Mikroinstalacje PV: doświadczenia i autokonsumpcja energii w sąsiedztwie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SolarDialog extends StatefulWidget {
  final String userName;

  const _SolarDialog({required this.userName});

  @override
  State<_SolarDialog> createState() => _SolarDialogState();
}

class _SolarDialogState extends State<_SolarDialog> {
  var _kind = SolarPostKind.tip;
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PV w sąsiedztwie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SolarPostKind>(
            initialValue: _kind,
            items: [
              for (final kind in SolarPostKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              SolarSharePost(
                id: 'pv-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wpis o PV'
                    : _title.text.trim(),
                body: _body.text.trim(),
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
