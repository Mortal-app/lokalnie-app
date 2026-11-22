import 'package:flutter/material.dart';

import '../models/local_art.dart';
import '../theme/widzew_ui.dart';

class LocalArtScreen extends StatefulWidget {
  final List<LocalArtWork> items;
  final String userName;
  final ValueChanged<LocalArtWork> onAdd;

  const LocalArtScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LocalArtScreen> createState() => _LocalArtScreenState();
}

class _LocalArtScreenState extends State<LocalArtScreen> {
  late List<LocalArtWork> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LocalArtWork>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ArtDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galeria sztuki lokalnej')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.palette_outlined),
        label: const Text('Dzieło'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Malarze, graficy i fotografowie z okolicy — wystawa i kontakt.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 72,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.kind == ArtKind.photo
                            ? const Color(0xFFB0BEC5)
                            : const Color(0xFFFFCC80),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.brush_outlined, size: 32),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.kind.label} · ${item.authorName}\nKontakt: ${item.contact}',
                    ),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ArtDialog extends StatefulWidget {
  final String userName;

  const _ArtDialog({required this.userName});

  @override
  State<_ArtDialog> createState() => _ArtDialogState();
}

class _ArtDialogState extends State<_ArtDialog> {
  final _title = TextEditingController();
  var _kind = ArtKind.paint;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wystawa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ArtKind>(
              initialValue: _kind,
              items: [
                for (final kind in ArtKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł dzieła'),
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
              LocalArtWork(
                id: 'la-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                contact: 'Wiadomość w aplikacji',
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
