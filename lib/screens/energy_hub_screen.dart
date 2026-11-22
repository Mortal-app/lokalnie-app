import 'package:flutter/material.dart';

import '../models/energy_experience.dart';
import '../theme/widzew_ui.dart';

class EnergyHubScreen extends StatefulWidget {
  final List<EnergyExperience> items;
  final String userName;
  final ValueChanged<EnergyExperience> onAdd;

  const EnergyHubScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<EnergyHubScreen> createState() => _EnergyHubScreenState();
}

class _EnergyHubScreenState extends State<EnergyHubScreen> {
  late List<EnergyExperience> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<EnergyExperience>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _EnergyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Osiedlowe źródła energii')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.solar_power_outlined),
        label: const Text('Dodaj doświadczenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Domy jednorodzinne w okolicy: PV, pompy ciepła i dotacje.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(switch (item.kind) {
                  EnergyKind.pv => Icons.solar_power_outlined,
                  EnergyKind.heatPump => Icons.thermostat_outlined,
                  EnergyKind.subsidy => Icons.savings_outlined,
                }),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.area}\n${item.body}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _EnergyDialog extends StatefulWidget {
  final String userName;

  const _EnergyDialog({required this.userName});

  @override
  State<_EnergyDialog> createState() => _EnergyDialogState();
}

class _EnergyDialogState extends State<_EnergyDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  var _kind = EnergyKind.pv;
  var _area = 'Twoja okolica';

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Doświadczenie z instalacji'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EnergyKind>(
              initialValue: _kind,
              items: [
                for (final kind in EnergyKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _area,
              items: const [
                DropdownMenuItem(
                  value: 'Twoja okolica',
                  child: Text('Twoja okolica'),
                ),
                DropdownMenuItem(value: 'Twoja okolica', child: Text('Twoja okolica')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _area = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _body,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 3,
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
              EnergyExperience(
                id: 'en-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                body: _body.text.trim(),
                kind: _kind,
                area: _area,
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
