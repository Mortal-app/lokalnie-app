import 'package:flutter/material.dart';

import '../models/classic_car.dart';
import '../theme/widzew_ui.dart';

class ClassicCarScreen extends StatefulWidget {
  final List<ClassicCarMeetup> items;
  final String userName;
  final ValueChanged<ClassicCarMeetup> onAdd;

  const ClassicCarScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ClassicCarScreen> createState() => _ClassicCarScreenState();
}

class _ClassicCarScreenState extends State<ClassicCarScreen> {
  late List<ClassicCarMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ClassicCarMeetup>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CarDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klasyki PRL i motoryzacja')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Spot'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Fiat 126p, Polonez, Duży Fiat i klasyczne Mercedesy — lokalne spoty na Widzewie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenText}\n${item.place} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CarDialog extends StatefulWidget {
  final String userName;

  const _CarDialog({required this.userName});

  @override
  State<_CarDialog> createState() => _CarDialogState();
}

class _CarDialogState extends State<_CarDialog> {
  var _kind = ClassicCarKind.fiat126p;
  final _title = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spot klasyków'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ClassicCarKind>(
            initialValue: _kind,
            items: [
              for (final kind in ClassicCarKind.values)
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
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
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
              ClassicCarMeetup(
                id: 'cc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Spot klasyków na Widzewie'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Niedziela rano'
                    : _when.text.trim(),
                place: 'Widzew',
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
