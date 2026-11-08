import 'package:flutter/material.dart';

import '../models/mobile_craft.dart';

class MobileCraftScreen extends StatefulWidget {
  final List<MobileCraftPro> items;
  final ValueChanged<MobileCraftPro> onAdd;

  const MobileCraftScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<MobileCraftScreen> createState() => _MobileCraftScreenState();
}

class _MobileCraftScreenState extends State<MobileCraftScreen> {
  late List<MobileCraftPro> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MobileCraftPro>(
      context: context,
      builder: (_) => const _CraftDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rzemiosło i usługi mobilne')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.miscellaneous_services_outlined),
        label: const Text('Poleć fachowca'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Ślusarz 24h, mobilny serwis opon i elektryk z polecenia sąsiadów — bezpośrednio na Widzewie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(item.name),
                subtitle: Text(
                  '${item.kind.label} · ${item.area}\nPolecony przez: ${item.endorsedBy}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CraftDialog extends StatefulWidget {
  const _CraftDialog();

  @override
  State<_CraftDialog> createState() => _CraftDialogState();
}

class _CraftDialogState extends State<_CraftDialog> {
  final _name = TextEditingController();
  var _kind = MobileCraftKind.locksmith;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fachowiec mobilny'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<MobileCraftKind>(
              initialValue: _kind,
              items: [
                for (final kind in MobileCraftKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Imię / firma'),
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
              MobileCraftPro(
                id: 'mc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                name: _name.text.trim().isEmpty
                    ? _kind.label
                    : _name.text.trim(),
                area: 'Widzew',
                endorsedBy: 'Sąsiad',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
