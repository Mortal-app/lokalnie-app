import 'package:flutter/material.dart';

import '../models/safety_school.dart';
import '../theme/widzew_ui.dart';

class SafetySchoolScreen extends StatefulWidget {
  final List<SafetyWorkshop> items;
  final String userName;
  final ValueChanged<SafetyWorkshop> onAdd;

  const SafetySchoolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SafetySchoolScreen> createState() => _SafetySchoolScreenState();
}

class _SafetySchoolScreenState extends State<SafetySchoolScreen> {
  late List<SafetyWorkshop> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SafetyWorkshop>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SafeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szkoła bezpieczeństwa')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.health_and_safety_outlined),
        label: const Text('Warsztat'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Darmowe warsztaty: pierwsza pomoc, obrona domowa, zabezpieczenie przed włamaniem — klub osiedlowy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenLabel}\n${item.place} · ${item.host}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SafeDialog extends StatefulWidget {
  final String userName;

  const _SafeDialog({required this.userName});

  @override
  State<_SafeDialog> createState() => _SafeDialogState();
}

class _SafeDialogState extends State<_SafeDialog> {
  final _title = TextEditingController();
  var _kind = SafetyClassKind.firstAid;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warsztat'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SafetyClassKind>(
              initialValue: _kind,
              items: [
                for (final kind in SafetyClassKind.values)
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
              SafetyWorkshop(
                id: 'ss-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'Sobota 10:00',
                place: 'Klub osiedlowy',
                host: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
