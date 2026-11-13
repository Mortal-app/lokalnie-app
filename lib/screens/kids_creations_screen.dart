import 'package:flutter/material.dart';

import '../models/kids_creation.dart';
import '../theme/widzew_ui.dart';

class KidsCreationsScreen extends StatefulWidget {
  final List<KidsCreation> items;
  final String userName;
  final ValueChanged<KidsCreation> onAdd;

  const KidsCreationsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<KidsCreationsScreen> createState() => _KidsCreationsScreenState();
}

class _KidsCreationsScreenState extends State<KidsCreationsScreen> {
  late List<KidsCreation> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<KidsCreation>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _KidsDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strefa twórczości dziecięcej')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.child_care_outlined),
        label: const Text('Dodaj pracę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Rysunki, projekty z klocków i prace szkolne młodych mieszkańców osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 72,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${item.kind.label} · ${item.childName}'),
                    Text(item.authorName),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KidsDialog extends StatefulWidget {
  final String userName;

  const _KidsDialog({required this.userName});

  @override
  State<_KidsDialog> createState() => _KidsDialogState();
}

class _KidsDialogState extends State<_KidsDialog> {
  final _title = TextEditingController();
  final _caption = TextEditingController();
  final _child = TextEditingController();
  var _kind = KidsCreationKind.drawing;

  @override
  void dispose() {
    _title.dispose();
    _caption.dispose();
    _child.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Praca dziecka'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<KidsCreationKind>(
              initialValue: _kind,
              items: [
                for (final kind in KidsCreationKind.values)
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
              controller: _child,
              decoration: const InputDecoration(labelText: 'Autor (dziecko)'),
            ),
            TextField(
              controller: _caption,
              decoration: const InputDecoration(labelText: 'Opis pracy'),
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
              KidsCreation(
                id: 'kid-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                caption: _caption.text.trim(),
                childName: _child.text.trim().isEmpty
                    ? 'Młody mieszkaniec'
                    : _child.text.trim(),
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
