import 'package:flutter/material.dart';

import '../models/tailor_offer.dart';
import '../theme/widzew_ui.dart';

class TailorScreen extends StatefulWidget {
  final List<TailorOffer> items;
  final String userName;
  final ValueChanged<TailorOffer> onAdd;

  const TailorScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<TailorScreen> createState() => _TailorScreenState();
}

class _TailorScreenState extends State<TailorScreen> {
  late List<TailorOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TailorOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TailorDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobilny krawiec w bloku')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.content_cut),
        label: const Text('Oferuję poprawki'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szycie, skracanie spodni, zamki i drobne naprawy odzieży u sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.checkroom_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.job.label} · ${item.staircase}\n${item.authorName}'
                  '${item.note.isEmpty ? '' : ' · ${item.note}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TailorDialog extends StatefulWidget {
  final String userName;

  const _TailorDialog({required this.userName});

  @override
  State<_TailorDialog> createState() => _TailorDialogState();
}

class _TailorDialogState extends State<_TailorDialog> {
  final _title = TextEditingController();
  var _job = TailorJob.hemPants;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usługa krawiecka'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TailorJob>(
              initialValue: _job,
              items: [
                for (final job in TailorJob.values)
                  DropdownMenuItem(value: job, child: Text(job.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _job = value);
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
              TailorOffer(
                id: 'tl-${DateTime.now().millisecondsSinceEpoch}',
                job: _job,
                title: _title.text.trim().isEmpty ? _job.label : _title.text.trim(),
                staircase: 'Klatka I',
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
