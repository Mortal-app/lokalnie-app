import 'package:flutter/material.dart';

import '../models/generation_bridge.dart';
import '../theme/widzew_ui.dart';

class GenerationBridgeScreen extends StatefulWidget {
  final List<GenerationBridgeOffer> items;
  final String userName;
  final ValueChanged<GenerationBridgeOffer> onAdd;

  const GenerationBridgeScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GenerationBridgeScreen> createState() => _GenerationBridgeScreenState();
}

class _GenerationBridgeScreenState extends State<GenerationBridgeScreen> {
  late List<GenerationBridgeOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GenerationBridgeOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _BridgeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Most pokoleń')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.groups_outlined),
        label: const Text('Wymiana umiejętności'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Młodzież: smartfon i komputer. Seniorzy: historie, kuchnia, szydełko.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: Text(item.title),
                subtitle: Text('${item.kind.label}\n${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BridgeDialog extends StatefulWidget {
  final String userName;

  const _BridgeDialog({required this.userName});

  @override
  State<_BridgeDialog> createState() => _BridgeDialogState();
}

class _BridgeDialogState extends State<_BridgeDialog> {
  final _title = TextEditingController();
  var _kind = BridgeKind.youthHelp;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Most pokoleń'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BridgeKind>(
              initialValue: _kind,
              items: [
                for (final kind in BridgeKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co oferujesz?'),
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
              GenerationBridgeOffer(
                id: 'gb-${DateTime.now().millisecondsSinceEpoch}',
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
