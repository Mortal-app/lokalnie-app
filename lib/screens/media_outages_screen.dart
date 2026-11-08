import 'package:flutter/material.dart';

import '../models/media_outage.dart';

class MediaOutagesScreen extends StatefulWidget {
  final List<MediaOutage> outages;
  final ValueChanged<MediaOutage> onAdd;
  final ValueChanged<String> onResolve;
  final void Function(String title, String body) onNotify;

  const MediaOutagesScreen({
    super.key,
    required this.outages,
    required this.onAdd,
    required this.onResolve,
    required this.onNotify,
  });

  @override
  State<MediaOutagesScreen> createState() => _MediaOutagesScreenState();
}

class _MediaOutagesScreenState extends State<MediaOutagesScreen> {
  late List<MediaOutage> _outages;

  @override
  void initState() {
    super.initState();
    _outages = List.of(widget.outages);
  }

  Future<void> _add() async {
    final created = await showDialog<MediaOutage>(
      context: context,
      builder: (_) => const _OutageDialog(),
    );
    if (created == null) return;
    setState(() => _outages = [created, ..._outages]);
    widget.onAdd(created);
    widget.onNotify(created.title, created.body);
  }

  void _resolve(MediaOutage outage) {
    setState(() {
      _outages = _outages
          .map(
            (item) =>
                item.id == outage.id ? item.copyWith(isActive: false) : item,
          )
          .toList();
    });
    widget.onResolve(outage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Piła i woda – awarie mediów')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.warning_amber_outlined),
        label: const Text('Nowe ostrzeżenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Szybkie ostrzeżenia: brak wody, wyłączenie prądu. Aktywne idą na baner startu i do powiadomień lokalnych.',
          ),
          const SizedBox(height: 12),
          for (final outage in _outages)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: outage.isActive ? Colors.red.shade50 : null,
              child: ListTile(
                leading: Icon(
                  outage.isActive
                      ? Icons.report_outlined
                      : Icons.check_circle_outline,
                ),
                title: Text(outage.title),
                subtitle: Text(
                  '${outage.kind.label} · ${outage.place}\n${outage.body}',
                ),
                isThreeLine: true,
                trailing: outage.isActive
                    ? TextButton(
                        onPressed: () => _resolve(outage),
                        child: const Text('Zakończ'),
                      )
                    : const Text('Zakończone'),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutageDialog extends StatefulWidget {
  const _OutageDialog();

  @override
  State<_OutageDialog> createState() => _OutageDialogState();
}

class _OutageDialogState extends State<_OutageDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _body = TextEditingController();
  var _kind = MediaOutageKind.water;

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ostrzeżenie o awarii'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<MediaOutageKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Medium'),
              items: MediaOutageKind.values
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
            TextField(
              controller: _body,
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
              MediaOutage(
                id: 'media-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                body: _body.text.trim(),
                kind: _kind,
                place: _place.text.trim(),
              ),
            );
          },
          child: const Text('Opublikuj'),
        ),
      ],
    );
  }
}
