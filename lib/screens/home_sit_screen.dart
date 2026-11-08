import 'package:flutter/material.dart';

import '../models/home_sit.dart';

class HomeSitScreen extends StatefulWidget {
  final List<HomeSitRequest> items;
  final String userName;
  final ValueChanged<HomeSitRequest> onAdd;

  const HomeSitScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<HomeSitScreen> createState() => _HomeSitScreenState();
}

class _HomeSitScreenState extends State<HomeSitScreen> {
  late List<HomeSitRequest> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<HomeSitRequest>(
      context: context,
      builder: (_) => _SitDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doglądanie mieszkania')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.home_outlined),
        label: const Text('Bezpieczne ogłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Szukam zaufanego sąsiada do wybrania poczty i podlania kwiatów podczas wyjazdu. Bez adresu w tytule — umowa na klatce.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_post_office_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenLabel}\n${item.mail ? 'Poczta' : ''} ${item.plants ? 'Kwiaty' : ''} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SitDialog extends StatefulWidget {
  final String userName;

  const _SitDialog({required this.userName});

  @override
  State<_SitDialog> createState() => _SitDialogState();
}

class _SitDialogState extends State<_SitDialog> {
  var _mail = true;
  var _plants = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wyjazd — pomoc'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Poczta'),
            value: _mail,
            onChanged: (value) => setState(() => _mail = value),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Podlewanie kwiatów'),
            value: _plants,
            onChanged: (value) => setState(() => _plants = value),
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
              HomeSitRequest(
                id: 'hs-${DateTime.now().millisecondsSinceEpoch}',
                title:
                    'Szukam zaufanego sąsiada do wybrania poczty i podlania kwiatów podczas wyjazdu',
                whenLabel: 'Termin do ustalenia na klatce',
                authorName: widget.userName,
                mail: _mail,
                plants: _plants,
              ),
            );
          },
          child: const Text('Opublikuj'),
        ),
      ],
    );
  }
}
