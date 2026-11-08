import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/safety_alert.dart';

class SafetyPatrolScreen extends StatefulWidget {
  final List<SafetyAlert> alerts;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<SafetyAlert> onAdd;
  final ValueChanged<String> onWitness;

  const SafetyPatrolScreen({
    super.key,
    required this.alerts,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
    required this.onWitness,
  });

  @override
  State<SafetyPatrolScreen> createState() => _SafetyPatrolScreenState();
}

class _SafetyPatrolScreenState extends State<SafetyPatrolScreen> {
  late List<SafetyAlert> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.of(widget.alerts);
  }

  Future<void> _add() async {
    final created = await showDialog<SafetyAlert>(
      context: context,
      builder: (_) => _SafetyDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _alerts = [created, ..._alerts]);
    widget.onAdd(created);
  }

  void _witness(SafetyAlert alert) {
    final next = alert.confirmWitness();
    if (next.iWitnessed == alert.iWitnessed) return;
    setState(() {
      _alerts = _alerts
          .map((item) => item.id == alert.id ? next : item)
          .toList();
    });
    widget.onWitness(alert.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patrol sąsiedzki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.security_outlined),
        label: const Text('Zgłoś aktywność'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Podejrzane aktywności na osiedlu. Potwierdź, jeśli widziałeś to samo.',
          ),
          const SizedBox(height: 12),
          for (final alert in _alerts)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${alert.kind.label} · ${alert.place}'),
                    Text(alert.description),
                    Text(
                      'Weryfikacja sąsiedzka: ${alert.witnessCount} · ${alert.authorName}',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: alert.iWitnessed
                            ? null
                            : () => _witness(alert),
                        child: Text(
                          alert.iWitnessed
                              ? 'Potwierdzono'
                              : 'Weryfikacja sąsiedzka – Widziałem to samo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SafetyDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _SafetyDialog({required this.userName, required this.subDistrict});

  @override
  State<_SafetyDialog> createState() => _SafetyDialogState();
}

class _SafetyDialogState extends State<_SafetyDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _description = TextEditingController();
  var _kind = SafetyAlertKind.other;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie na patrol'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SafetyAlertKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: SafetyAlertKind.values
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
              SafetyAlert(
                id: 'safe-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
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
