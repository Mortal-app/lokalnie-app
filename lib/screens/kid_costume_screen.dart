import 'package:flutter/material.dart';

import '../models/kid_costume.dart';
import '../theme/widzew_ui.dart';

class KidCostumeScreen extends StatefulWidget {
  final List<KidCostumeOffer> items;
  final String userName;
  final ValueChanged<KidCostumeOffer> onAdd;

  const KidCostumeScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<KidCostumeScreen> createState() => _KidCostumeScreenState();
}

class _KidCostumeScreenState extends State<KidCostumeScreen> {
  late List<KidCostumeOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<KidCostumeOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CostumeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kostiumy dla dzieci')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.checkroom_outlined),
        label: const Text('Stroje'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wypożyczanie i wymiana strojów na bale, przedstawienia szkolne i Halloween.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.checkroom_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.occasion.label} · rozmiar ${item.size}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CostumeDialog extends StatefulWidget {
  final String userName;

  const _CostumeDialog({required this.userName});

  @override
  State<_CostumeDialog> createState() => _CostumeDialogState();
}

class _CostumeDialogState extends State<_CostumeDialog> {
  var _occasion = CostumeOccasion.carnival;
  final _title = TextEditingController();
  final _size = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kostium'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<CostumeOccasion>(
            initialValue: _occasion,
            items: [
              for (final occasion in CostumeOccasion.values)
                DropdownMenuItem(value: occasion, child: Text(occasion.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _occasion = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Strój'),
          ),
          TextField(
            controller: _size,
            decoration: const InputDecoration(labelText: 'Rozmiar'),
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
              KidCostumeOffer(
                id: 'kc-${DateTime.now().millisecondsSinceEpoch}',
                occasion: _occasion,
                title: _title.text.trim().isEmpty
                    ? 'Kostium do wymiany'
                    : _title.text.trim(),
                size: _size.text.trim().isEmpty ? 'uniwersalny' : _size.text.trim(),
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
