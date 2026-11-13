import 'package:flutter/material.dart';

import '../models/garden_furniture.dart';
import '../theme/widzew_ui.dart';

class GardenFurnitureScreen extends StatefulWidget {
  final List<GardenFurnitureTip> items;
  final String userName;
  final ValueChanged<GardenFurnitureTip> onAdd;

  const GardenFurnitureScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GardenFurnitureScreen> createState() => _GardenFurnitureScreenState();
}

class _GardenFurnitureScreenState extends State<GardenFurnitureScreen> {
  late List<GardenFurnitureTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GardenFurnitureTip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FurnDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meble ogrodowe i balkonowe')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.weekend_outlined),
        label: const Text('Porada / pomoc'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Olejowanie teaku, odnawianie krzeseł i montaż osłon balkonowych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.weekend_outlined),
                title: Text(item.title),
                subtitle: Text('${item.body} · ${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _FurnDialog extends StatefulWidget {
  final String userName;

  const _FurnDialog({required this.userName});

  @override
  State<_FurnDialog> createState() => _FurnDialogState();
}

class _FurnDialogState extends State<_FurnDialog> {
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
      title: const Text('Meble / osłony'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Porada'),
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
              GardenFurnitureTip(
                id: 'gf-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Konserwacja mebli'
                    : _title.text.trim(),
                body: _body.text.trim(),
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
