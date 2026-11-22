import 'package:flutter/material.dart';

import '../models/pet_pro.dart';
import '../theme/widzew_ui.dart';

class PetProScreen extends StatefulWidget {
  final List<PetProReview> items;
  final String userName;
  final ValueChanged<PetProReview> onAdd;

  const PetProScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PetProScreen> createState() => _PetProScreenState();
}

class _PetProScreenState extends State<PetProScreen> {
  late List<PetProReview> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PetProReview>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ProDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weterynarze i groomerzy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Opinia'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Rekomendacje gabinetów weterynaryjnych i salonów pielęgnacji psów na dzielnicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pets),
                title: Text(item.name),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.review} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProDialog extends StatefulWidget {
  final String userName;

  const _ProDialog({required this.userName});

  @override
  State<_ProDialog> createState() => _ProDialogState();
}

class _ProDialogState extends State<_ProDialog> {
  var _kind = PetProKind.vet;
  final _name = TextEditingController();
  final _review = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rekomendacja'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PetProKind>(
            initialValue: _kind,
            items: [
              for (final kind in PetProKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nazwa'),
          ),
          TextField(
            controller: _review,
            decoration: const InputDecoration(labelText: 'Opinia'),
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
              PetProReview(
                id: 'pp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                name: _name.text.trim().isEmpty
                    ? 'Gabinet w Twojej okolicy'
                    : _name.text.trim(),
                place: 'Okolica',
                review: _review.text.trim(),
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
