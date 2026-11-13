import 'package:flutter/material.dart';

import '../models/forest_forage.dart';
import '../theme/widzew_ui.dart';

class ForestForageScreen extends StatefulWidget {
  final List<ForestForageTrip> items;
  final String userName;
  final ValueChanged<ForestForageTrip> onAdd;

  const ForestForageScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ForestForageScreen> createState() => _ForestForageScreenState();
}

class _ForestForageScreenState extends State<ForestForageScreen> {
  late List<ForestForageTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ForestForageTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ForageDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grzyby i borówka')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.park_outlined),
        label: const Text('Wyjazd'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Carpooling do lasów w stronę Tuszyna, Koluszek i Strykowa — wolne miejsca w aucie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.park_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.meetingPoint}\n${item.seats} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ForageDialog extends StatefulWidget {
  final String userName;

  const _ForageDialog({required this.userName});

  @override
  State<_ForageDialog> createState() => _ForageDialogState();
}

class _ForageDialogState extends State<_ForageDialog> {
  final _title = TextEditingController();
  final _when = TextEditingController();
  final _seats = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    _seats.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wyprawa leśna'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Kierunek lasu'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
          ),
          TextField(
            controller: _seats,
            decoration: const InputDecoration(labelText: 'Wolne miejsca'),
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
              ForestForageTrip(
                id: 'ff-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Las pod Łodzią'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Sobota rano'
                    : _when.text.trim(),
                meetingPoint: 'Pętla Widzew Wschód',
                seats: _seats.text.trim().isEmpty
                    ? 'Miejsca do uzgodnienia'
                    : _seats.text.trim(),
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
