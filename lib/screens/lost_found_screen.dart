import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/lost_found_item.dart';
import '../theme/widzew_ui.dart';

class LostFoundScreen extends StatefulWidget {
  final List<LostFoundItem> items;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<LostFoundItem> onAdd;
  final ValueChanged<String> onMarkReturned;

  const LostFoundScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
    required this.onMarkReturned,
  });

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  late List<LostFoundItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LostFoundItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _LostDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _returned(LostFoundItem item) {
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(returned: true) : entry,
          )
          .toList();
    });
    widget.onMarkReturned(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biuro rzeczy znalezionych')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.search),
        label: const Text('Zgłoś zgubę / znalezisko'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Zgubiono / znaleziono na osiedlu: klucze, portfele, dokumenty, koty i psy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.returned
                      ? Icons.check_circle_outline
                      : Icons.help_outline,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.side.label} · ${item.kind.label} · ${item.place}\n'
                  '${item.description}\n'
                  '${item.returned ? 'Odnaleziono / powrócił do właściciela' : item.authorName}',
                ),
                isThreeLine: true,
                trailing: item.returned
                    ? null
                    : TextButton(
                        onPressed: () => _returned(item),
                        child: const Text('Odnaleziono'),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LostDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _LostDialog({required this.userName, required this.subDistrict});

  @override
  State<_LostDialog> createState() => _LostDialogState();
}

class _LostDialogState extends State<_LostDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _place = TextEditingController();
  var _kind = LostFoundKind.keys;
  var _side = LostFoundSide.lost;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgubiono / znaleziono'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LostFoundSide>(
              initialValue: _side,
              decoration: const InputDecoration(labelText: 'Typ'),
              items: LostFoundSide.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _side = value);
              },
            ),
            DropdownButtonFormField<LostFoundKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Co'),
              items: LostFoundKind.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              decoration: const InputDecoration(labelText: 'Osiedle'),
              items: Announcement.subDistricts
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _subDistrict = value);
              },
            ),
            TextField(
              controller: _description,
              maxLines: 2,
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              LostFoundItem(
                id: 'lf-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                side: _side,
                place: _place.text.trim().isEmpty
                    ? _subDistrict
                    : _place.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
