import 'package:flutter/material.dart';

import '../models/window_view.dart';
import '../theme/widzew_ui.dart';

class WindowViewScreen extends StatefulWidget {
  final List<WindowViewPhoto> items;
  final String userName;
  final ValueChanged<WindowViewPhoto> onAdd;

  const WindowViewScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WindowViewScreen> createState() => _WindowViewScreenState();
}

class _WindowViewScreenState extends State<WindowViewScreen> {
  late List<WindowViewPhoto> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WindowViewPhoto>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ViewDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widzew w obiektywie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.wb_twilight_outlined),
        label: const Text('Dodaj widok'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Galeria wschodów i zachodów nad blokowiskami oraz widoków z okien — opis zamiast pliku (testy).',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.wb_twilight_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.caption} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ViewDialog extends StatefulWidget {
  final String userName;

  const _ViewDialog({required this.userName});

  @override
  State<_ViewDialog> createState() => _ViewDialogState();
}

class _ViewDialogState extends State<_ViewDialog> {
  var _kind = WindowViewKind.sunrise;
  final _title = TextEditingController();
  final _caption = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zdjęcie z okna'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<WindowViewKind>(
            initialValue: _kind,
            items: [
              for (final kind in WindowViewKind.values)
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
            controller: _caption,
            decoration: const InputDecoration(labelText: 'Opis zdjęcia'),
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
              WindowViewPhoto(
                id: 'wv-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Widok z bloku'
                    : _title.text.trim(),
                caption: _caption.text.trim().isEmpty
                    ? 'Opis zdjęcia z okna.'
                    : _caption.text.trim(),
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
