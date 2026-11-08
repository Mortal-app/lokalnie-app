import 'package:flutter/material.dart';

import '../models/bike_help.dart';

class BikeHelpScreen extends StatefulWidget {
  final List<BikeHelpRequest> requests;
  final List<BikeRack> racks;
  final String userName;
  final ValueChanged<BikeHelpRequest> onAdd;
  final ValueChanged<String> onOffer;

  const BikeHelpScreen({
    super.key,
    required this.requests,
    required this.racks,
    required this.userName,
    required this.onAdd,
    required this.onOffer,
  });

  @override
  State<BikeHelpScreen> createState() => _BikeHelpScreenState();
}

class _BikeHelpScreenState extends State<BikeHelpScreen> {
  late List<BikeHelpRequest> _requests;

  @override
  void initState() {
    super.initState();
    _requests = List.of(widget.requests);
  }

  Future<void> _add() async {
    final created = await showDialog<BikeHelpRequest>(
      context: context,
      builder: (_) => _BikeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _requests = [created, ..._requests]);
    widget.onAdd(created);
  }

  void _offer(BikeHelpRequest request) {
    if (request.offered) return;
    setState(() {
      _requests = _requests
          .map(
            (item) =>
                item.id == request.id ? item.copyWith(offered: true) : item,
          )
          .toList();
    });
    widget.onOffer(request.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pogotowie rowerowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pedal_bike_outlined),
        label: const Text('Potrzebuję pomocy'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kto pożyczy pompkę / klucz do suportu / pomoże w centrowaniu koła — serwis na klatce.',
          ),
          const SizedBox(height: 12),
          for (final item in _requests)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.build_circle_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.staircase} · ${item.authorName}\n${item.note}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: item.offered ? null : () => _offer(item),
                  child: Text(item.offered ? 'Pomogę' : 'Mogę pożyczyć'),
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Mapka stojaków rowerowych',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final rack in widget.racks)
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(rack.name),
                subtitle: Text('${rack.place}\n${rack.hint}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BikeDialog extends StatefulWidget {
  final String userName;

  const _BikeDialog({required this.userName});

  @override
  State<_BikeDialog> createState() => _BikeDialogState();
}

class _BikeDialogState extends State<_BikeDialog> {
  final _note = TextEditingController();
  final _staircase = TextEditingController(text: 'Klatka I');
  var _kind = BikeHelpKind.pump;

  @override
  void dispose() {
    _note.dispose();
    _staircase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ogłoszenie rowerowe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BikeHelpKind>(
              initialValue: _kind,
              items: [
                for (final kind in BikeHelpKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _staircase,
              decoration: const InputDecoration(labelText: 'Klatka'),
            ),
            TextField(
              controller: _note,
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
              BikeHelpRequest(
                id: 'bike-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                note: _note.text.trim().isEmpty
                    ? 'Kto pożyczy ${_kind.label.toLowerCase()}?'
                    : _note.text.trim(),
                authorName: widget.userName,
                staircase: _staircase.text.trim().isEmpty
                    ? 'Klatka I'
                    : _staircase.text.trim(),
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
