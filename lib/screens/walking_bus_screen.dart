import 'package:flutter/material.dart';

import '../models/walking_bus.dart';
import '../theme/widzew_ui.dart';

class WalkingBusScreen extends StatefulWidget {
  final List<WalkingBusShift> shifts;
  final String userName;
  final ValueChanged<WalkingBusShift> onAdd;

  const WalkingBusScreen({
    super.key,
    required this.shifts,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WalkingBusScreen> createState() => _WalkingBusScreenState();
}

class _WalkingBusScreenState extends State<WalkingBusScreen> {
  late List<WalkingBusShift> _shifts;

  @override
  void initState() {
    super.initState();
    _shifts = List.of(widget.shifts);
  }

  Future<void> _add() async {
    final created = await showDialog<WalkingBusShift>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _WalkDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _shifts = [created, ..._shifts]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szkolny autobus pieszy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_walk),
        label: const Text('Dzisiaj ja odprowadzam'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne odprowadzanie do SP 114, SP 34 i SP 141. Harmonogram klatek.',
          ),
          const SizedBox(height: 12),
          for (final shift in _shifts)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(
                  '${shift.dayLabel}: ${shift.walkerName} odprowadza dzieci',
                ),
                subtitle: Text(
                  '${shift.school.label} · ${shift.time}\nKlatka: ${shift.staircase}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _WalkDialog extends StatefulWidget {
  final String userName;

  const _WalkDialog({required this.userName});

  @override
  State<_WalkDialog> createState() => _WalkDialogState();
}

class _WalkDialogState extends State<_WalkDialog> {
  final _time = TextEditingController(text: '7:30');
  final _staircase = TextEditingController();
  var _school = WalkingSchool.sp114;

  @override
  void dispose() {
    _time.dispose();
    _staircase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dzisiaj ja odprowadzam dzieci z naszej klatki'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WalkingSchool>(
              initialValue: _school,
              decoration: const InputDecoration(labelText: 'Szkoła'),
              items: WalkingSchool.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _school = value);
              },
            ),
            TextField(
              controller: _time,
              decoration: const InputDecoration(labelText: 'Godzina'),
            ),
            TextField(
              controller: _staircase,
              decoration: const InputDecoration(labelText: 'Klatka / adres'),
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
              WalkingBusShift(
                id: 'wb-${DateTime.now().microsecondsSinceEpoch}',
                school: _school,
                time: _time.text.trim().isEmpty ? '7:30' : _time.text.trim(),
                staircase: _staircase.text.trim().isEmpty
                    ? 'Nasza klatka'
                    : _staircase.text.trim(),
                walkerName: widget.userName,
                dayLabel: 'Dziś',
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
