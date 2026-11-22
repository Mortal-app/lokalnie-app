import 'package:flutter/material.dart';

import '../models/student_ride.dart';
import '../theme/widzew_ui.dart';

class StudentRidesScreen extends StatefulWidget {
  final List<StudentRide> items;
  final String userName;
  final ValueChanged<StudentRide> onAdd;

  const StudentRidesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<StudentRidesScreen> createState() => _StudentRidesScreenState();
}

class _StudentRidesScreenState extends State<StudentRidesScreen> {
  late List<StudentRide> _items;
  CampusDest? _campus;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  List<StudentRide> get _visible => _campus == null
      ? _items
      : _items.where((item) => item.campus == _campus).toList();

  Future<void> _add() async {
    final created = await showDialog<StudentRide>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _StudentDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dojazdy studenckie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.school_outlined),
        label: const Text('Dodaj kurs'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Carpooling na Politechnikę Łódzką i Uniwersytet Łódzki z okolicy.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _campus == null,
                onSelected: (_) => setState(() => _campus = null),
              ),
              for (final campus in CampusDest.values.take(2))
                FilterChip(
                  label: Text(campus.label),
                  selected: _campus == campus,
                  onSelected: (_) => setState(() => _campus = campus),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text('${item.fromDistrict} → ${item.campus.label}'),
                subtitle: Text(
                  '${item.time} · ${item.seats} miejsca · ${item.authorName}'
                  '${item.note.isEmpty ? '' : '\n${item.note}'}',
                ),
                isThreeLine: item.note.isNotEmpty,
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentDialog extends StatefulWidget {
  final String userName;

  const _StudentDialog({required this.userName});

  @override
  State<_StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<_StudentDialog> {
  var _campus = CampusDest.politechnika;
  var _from = 'Twoja okolica';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kurs na uczelnię'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CampusDest>(
              initialValue: _campus,
              items: [
                for (final campus in CampusDest.values)
                  DropdownMenuItem(value: campus, child: Text(campus.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _campus = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _from,
              items: const [
                DropdownMenuItem(
                  value: 'Twoja okolica',
                  child: Text('Twoja okolica'),
                ),
                DropdownMenuItem(value: 'Twoja okolica', child: Text('Twoja okolica')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _from = value);
              },
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
              StudentRide(
                id: 'st-${DateTime.now().millisecondsSinceEpoch}',
                campus: _campus,
                fromDistrict: _from,
                time: '7:40',
                seats: 2,
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
