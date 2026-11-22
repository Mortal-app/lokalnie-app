import 'package:flutter/material.dart';

import '../models/craft_workshop.dart';
import '../theme/widzew_ui.dart';

class CraftWorkshopScreen extends StatefulWidget {
  final List<CraftWorkshopOffer> items;
  final String userName;
  final ValueChanged<CraftWorkshopOffer> onAdd;

  const CraftWorkshopScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CraftWorkshopScreen> createState() => _CraftWorkshopScreenState();
}

class _CraftWorkshopScreenState extends State<CraftWorkshopScreen> {
  late List<CraftWorkshopOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CraftWorkshopOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CraftDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warsztat galanterii i rękodzieła')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.content_cut_outlined),
        label: const Text('Ogłoszenie twórcy'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Twórcy w skórze, drewnie i tkaninach artystycznych z okolicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.material.label} · ${item.area}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CraftDialog extends StatefulWidget {
  final String userName;

  const _CraftDialog({required this.userName});

  @override
  State<_CraftDialog> createState() => _CraftDialogState();
}

class _CraftDialogState extends State<_CraftDialog> {
  final _title = TextEditingController();
  var _material = CraftMaterial.leather;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rękodzieło'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CraftMaterial>(
              initialValue: _material,
              items: [
                for (final material in CraftMaterial.values)
                  DropdownMenuItem(
                    value: material,
                    child: Text(material.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _material = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis'),
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
              CraftWorkshopOffer(
                id: 'cw-${DateTime.now().millisecondsSinceEpoch}',
                material: _material,
                title: _title.text.trim().isEmpty
                    ? _material.label
                    : _title.text.trim(),
                area: 'Twoja okolica',
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
