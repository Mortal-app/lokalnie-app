import 'package:flutter/material.dart';

import '../models/carpet_vac.dart';
import '../theme/widzew_ui.dart';

class CarpetVacScreen extends StatefulWidget {
  final List<CarpetVacOffer> items;
  final String userName;
  final ValueChanged<CarpetVacOffer> onAdd;

  const CarpetVacScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CarpetVacScreen> createState() => _CarpetVacScreenState();
}

class _CarpetVacScreenState extends State<CarpetVacScreen> {
  late List<CarpetVacOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CarpetVacOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _VacDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dywany i odkurzacze piorące')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.cleaning_services_outlined),
        label: const Text('Ogłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wypożyczalnia odkurzaczy piorących i wspólne czyszczenie dywanów na klatce.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.place}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _VacDialog extends StatefulWidget {
  final String userName;

  const _VacDialog({required this.userName});

  @override
  State<_VacDialog> createState() => _VacDialogState();
}

class _VacDialogState extends State<_VacDialog> {
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
      title: const Text('Odkurzacz / dywan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              CarpetVacOffer(
                id: 'cv-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Odkurzacz piorący'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: 'Klatka schodowa',
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
