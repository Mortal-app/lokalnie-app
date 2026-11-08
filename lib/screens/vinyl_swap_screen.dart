import 'package:flutter/material.dart';

import '../models/vinyl_swap.dart';

class VinylSwapScreen extends StatefulWidget {
  final List<VinylSwapItem> items;
  final String userName;
  final ValueChanged<VinylSwapItem> onAdd;

  const VinylSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<VinylSwapScreen> createState() => _VinylSwapScreenState();
}

class _VinylSwapScreenState extends State<VinylSwapScreen> {
  late List<VinylSwapItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<VinylSwapItem>(
      context: context,
      builder: (_) => _VinylDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giełda winyli i kaset')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.album_outlined),
        label: const Text('Dodaj płytę / kasetę'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana i sprzedaż winyli, CD i kaset magnetofonowych — kolekcjonerzy z Widzewa.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.library_music_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.artist}\n${item.forSale ? 'Sprzedaż' : 'Wymiana'} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _VinylDialog extends StatefulWidget {
  final String userName;

  const _VinylDialog({required this.userName});

  @override
  State<_VinylDialog> createState() => _VinylDialogState();
}

class _VinylDialogState extends State<_VinylDialog> {
  final _title = TextEditingController();
  final _artist = TextEditingController();
  var _kind = VinylMediaKind.vinyl;
  var _sale = false;

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nośnik'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<VinylMediaKind>(
              initialValue: _kind,
              items: [
                for (final kind in VinylMediaKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sprzedaż (nie tylko wymiana)'),
              value: _sale,
              onChanged: (value) => setState(() => _sale = value),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _artist,
              decoration: const InputDecoration(labelText: 'Wykonawca'),
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
              VinylSwapItem(
                id: 'vs-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                artist: _artist.text.trim().isEmpty
                    ? 'Różni'
                    : _artist.text.trim(),
                authorName: widget.userName,
                forSale: _sale,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
