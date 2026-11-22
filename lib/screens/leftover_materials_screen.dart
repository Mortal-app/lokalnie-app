import 'package:flutter/material.dart';

import '../models/leftover_material.dart';
import '../theme/widzew_ui.dart';

class LeftoverMaterialsScreen extends StatefulWidget {
  final List<LeftoverMaterial> items;
  final String userName;
  final ValueChanged<LeftoverMaterial> onAdd;

  const LeftoverMaterialsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LeftoverMaterialsScreen> createState() =>
      _LeftoverMaterialsScreenState();
}

class _LeftoverMaterialsScreenState extends State<LeftoverMaterialsScreen> {
  late List<LeftoverMaterial> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LeftoverMaterial>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _MaterialDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resztki po remoncie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.format_paint_outlined),
        label: const Text('Zostało mi po remoncie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Klej, panele, farba i płytki — oddanie lub odsprzedaż za grosze.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.priceLabel}\n${item.place} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _MaterialDialog extends StatefulWidget {
  final String userName;

  const _MaterialDialog({required this.userName});

  @override
  State<_MaterialDialog> createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<_MaterialDialog> {
  final _title = TextEditingController();
  var _kind = LeftoverKind.paint;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zostało mi po remoncie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LeftoverKind>(
              initialValue: _kind,
              items: [
                for (final kind in LeftoverKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co zostało?'),
            ),
          ],
        ),
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
              LeftoverMaterial(
                id: 'lm-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Zostało mi po remoncie: ${_kind.label.toLowerCase()}'
                    : _title.text.trim(),
                priceLabel: 'Za grosze',
                place: 'Okolica',
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
