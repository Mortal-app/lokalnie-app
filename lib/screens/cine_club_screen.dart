import 'package:flutter/material.dart';

import '../models/cine_club.dart';

class CineClubScreen extends StatefulWidget {
  final List<CineScreening> items;
  final ValueChanged<CineScreening> onAdd;
  final ValueChanged<String> onReserve;

  const CineClubScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onReserve,
  });

  @override
  State<CineClubScreen> createState() => _CineClubScreenState();
}

class _CineClubScreenState extends State<CineClubScreen> {
  late List<CineScreening> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CineScreening>(
      context: context,
      builder: (_) => const _CineDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _reserve(CineScreening item) {
    if (item.reserved >= item.seats) return;
    setState(() {
      _items = _items
          .map(
            (entry) => entry.id == item.id
                ? entry.copyWith(reserved: entry.reserved + 1)
                : entry,
          )
          .toList();
    });
    widget.onReserve(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kino studyjne i DKF')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.theaters_outlined),
        label: const Text('Nowy seans'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Seanse w świetlicy i kino niezależne w plenerze. Rezerwacja darmowego miejsca.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.movie_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.place} · ${item.whenLabel}\nMiejsca: ${item.reserved}/${item.seats} (darmowe)',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: item.reserved >= item.seats
                      ? null
                      : () => _reserve(item),
                  child: Text(
                    item.reserved >= item.seats ? 'Brak miejsc' : 'Rezerwuję',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CineDialog extends StatefulWidget {
  const _CineDialog();

  @override
  State<_CineDialog> createState() => _CineDialogState();
}

class _CineDialogState extends State<_CineDialog> {
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seans'),
      content: TextField(
        controller: _title,
        decoration: const InputDecoration(labelText: 'Tytuł filmu / cyklu'),
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
              CineScreening(
                id: 'cc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Seans DKF'
                    : _title.text.trim(),
                place: 'Świetlica osiedlowa',
                whenLabel: 'Piątek 19:00',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
