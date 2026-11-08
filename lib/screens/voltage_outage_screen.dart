import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/voltage_outage.dart';

class VoltageOutageScreen extends StatefulWidget {
  final List<VoltageOutageReport> items;
  final String userName;
  final ValueChanged<VoltageOutageReport> onAdd;

  const VoltageOutageScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<VoltageOutageScreen> createState() => _VoltageOutageScreenState();
}

class _VoltageOutageScreenState extends State<VoltageOutageScreen> {
  late List<VoltageOutageReport> _items;

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<VoltageOutageReport>(
      context: context,
      builder: (_) => _VoltageDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zaniki napięcia i faz')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.bolt_outlined),
        label: const Text('Zgłoś zanik'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Skoki napięcia i zaniki prądu na ulicach Widzewa Wschodu i Olechowa.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa zaniku',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.bolt, color: Color(0xFFF9A825)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.electrical_services_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.district} · ${item.street}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _VoltageDialog extends StatefulWidget {
  final String userName;

  const _VoltageDialog({required this.userName});

  @override
  State<_VoltageDialog> createState() => _VoltageDialogState();
}

class _VoltageDialogState extends State<_VoltageDialog> {
  final _street = TextEditingController();
  final _note = TextEditingController();
  var _kind = VoltageKind.blackout;
  var _district = 'Widzew Wschód';

  @override
  void dispose() {
    _street.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie zaniku'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<VoltageKind>(
              initialValue: _kind,
              items: [
                for (final kind in VoltageKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _district,
              items: const [
                DropdownMenuItem(
                  value: 'Widzew Wschód',
                  child: Text('Widzew Wschód'),
                ),
                DropdownMenuItem(value: 'Olechów', child: Text('Olechów')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _district = value);
              },
            ),
            TextField(
              controller: _street,
              decoration: const InputDecoration(labelText: 'Ulica'),
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
              VoltageOutageReport(
                id: 'vo-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                street: _street.text.trim().isEmpty
                    ? 'ul. osiedlowa'
                    : _street.text.trim(),
                district: _district,
                note: _note.text.trim(),
                authorName: widget.userName,
                pos: StationAlign.center,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
