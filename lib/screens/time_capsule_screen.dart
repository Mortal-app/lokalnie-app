import 'package:flutter/material.dart';

import '../models/time_capsule.dart';

class TimeCapsuleScreen extends StatefulWidget {
  final List<TimeCapsuleEntry> items;
  final String userName;
  final ValueChanged<TimeCapsuleEntry> onAdd;

  const TimeCapsuleScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<TimeCapsuleScreen> {
  late List<TimeCapsuleEntry> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TimeCapsuleEntry>(
      context: context,
      builder: (_) => _CapsuleDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kapsuła czasu Widzewa')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.hourglass_empty),
        label: const Text('Wspomnienie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Księga wspomnień i zdjęć osiedla. Wspólny list do przyszłych pokoleń otworzy się za 10 lat.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.isSharedLetter
                      ? Icons.lock_clock
                      : Icons.photo_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  item.isSharedLetter
                      ? 'Zapieczętowany ${item.sealedAt} · otwarcie ${item.opensAt}\nTreść listu ukryta do 28.10.2036.'
                      : '${item.body}\n${item.authorName} · pieczęć ${item.sealedAt}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CapsuleDialog extends StatefulWidget {
  final String userName;

  const _CapsuleDialog({required this.userName});

  @override
  State<_CapsuleDialog> createState() => _CapsuleDialogState();
}

class _CapsuleDialogState extends State<_CapsuleDialog> {
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
      title: const Text('Wpis do kapsuły'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Wspomnienie'),
            maxLines: 3,
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
              TimeCapsuleEntry(
                id: 'tc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wspomnienie z Widzewa'
                    : _title.text.trim(),
                body: _body.text.trim(),
                authorName: widget.userName,
                sealedAt: '28.10.2026',
                opensAt: '28.10.2036',
              ),
            );
          },
          child: const Text('Pieczętuj'),
        ),
      ],
    );
  }
}
