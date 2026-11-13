import 'package:flutter/material.dart';

import '../models/terrarium_pet.dart';
import '../theme/widzew_ui.dart';

class TerrariumPetScreen extends StatefulWidget {
  final List<TerrariumOffer> items;
  final String userName;
  final ValueChanged<TerrariumOffer> onAdd;

  const TerrariumPetScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<TerrariumPetScreen> createState() => _TerrariumPetScreenState();
}

class _TerrariumPetScreenState extends State<TerrariumPetScreen> {
  late List<TerrariumOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TerrariumOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TerraDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terrarystyka i egzotyka')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.bug_report_outlined),
        label: const Text('Wpis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Hodowcy gekonów, patyczaków i żółwi: podłoża, żywy pokarm i wyposażenie terrariów — osobno od akwarium i ptaków.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _TerraDialog extends StatefulWidget {
  final String userName;

  const _TerraDialog({required this.userName});

  @override
  State<_TerraDialog> createState() => _TerraDialogState();
}

class _TerraDialogState extends State<_TerraDialog> {
  var _kind = TerraKind.gecko;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terrarium / egzotyka'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<TerraKind>(
            initialValue: _kind,
            items: [
              for (final kind in TerraKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
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
              TerrariumOffer(
                id: 'tp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
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
