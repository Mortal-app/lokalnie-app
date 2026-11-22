import 'package:flutter/material.dart';

import '../models/smile_gift.dart';
import '../theme/widzew_ui.dart';

class SmileGiftsScreen extends StatefulWidget {
  final List<SmileGift> items;
  final String userName;
  final ValueChanged<SmileGift> onAdd;

  const SmileGiftsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SmileGiftsScreen> createState() => _SmileGiftsScreenState();
}

class _SmileGiftsScreenState extends State<SmileGiftsScreen> {
  late List<SmileGift> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SmileGift>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _GiftDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oddam za uśmiech')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.favorite),
        label: const Text('Oddaj za darmo'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Czysty dar: odzież, zabawki i meble całkowicie za darmo. Serce oznacza prezent.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFFC62828)),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GiftDialog extends StatefulWidget {
  final String userName;

  const _GiftDialog({required this.userName});

  @override
  State<_GiftDialog> createState() => _GiftDialogState();
}

class _GiftDialogState extends State<_GiftDialog> {
  final _title = TextEditingController();
  var _kind = SmileGiftKind.clothes;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oddam za uśmiech'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SmileGiftKind>(
              initialValue: _kind,
              items: [
                for (final kind in SmileGiftKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co oddajesz?'),
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
              SmileGift(
                id: 'sg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? '${_kind.label} — oddam za uśmiech'
                    : _title.text.trim(),
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
