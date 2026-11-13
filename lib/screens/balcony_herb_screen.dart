import 'package:flutter/material.dart';

import '../models/balcony_herb.dart';
import '../theme/widzew_ui.dart';

class BalconyHerbScreen extends StatefulWidget {
  final List<BalconyHerbOffer> items;
  final String userName;
  final ValueChanged<BalconyHerbOffer> onAdd;

  const BalconyHerbScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BalconyHerbScreen> createState() => _BalconyHerbScreenState();
}

class _BalconyHerbScreenState extends State<BalconyHerbScreen> {
  late List<BalconyHerbOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BalconyHerbOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _HerbDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zioła balkonowe')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_florist_outlined),
        label: const Text('Szczepka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Mięta, bazylia, rozmaryn — katalog i giełda szczepek oraz nasion z balkonów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_florist_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.care} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _HerbDialog extends StatefulWidget {
  final String userName;

  const _HerbDialog({required this.userName});

  @override
  State<_HerbDialog> createState() => _HerbDialogState();
}

class _HerbDialogState extends State<_HerbDialog> {
  var _kind = HerbKind.mint;
  final _title = TextEditingController();
  final _care = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _care.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zioło'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<HerbKind>(
            initialValue: _kind,
            items: [
              for (final kind in HerbKind.values)
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
            controller: _care,
            decoration: const InputDecoration(labelText: 'Pielęgnacja'),
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
              BalconyHerbOffer(
                id: 'bh-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Zioło z balkonu'
                    : _title.text.trim(),
                care: _care.text.trim(),
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
