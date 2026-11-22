import 'package:flutter/material.dart';

import '../models/eco_report.dart';
import '../theme/widzew_ui.dart';

class EcoPatrolScreen extends StatefulWidget {
  final List<EcoReport> reports;
  final String userSubDistrict;
  final ValueChanged<EcoReport> onAdd;
  final ValueChanged<String> onMarkAccepted;

  const EcoPatrolScreen({
    super.key,
    required this.reports,
    required this.userSubDistrict,
    required this.onAdd,
    required this.onMarkAccepted,
  });

  @override
  State<EcoPatrolScreen> createState() => _EcoPatrolScreenState();
}

class _EcoPatrolScreenState extends State<EcoPatrolScreen> {
  late List<EcoReport> _reports;

  @override
  void initState() {
    super.initState();
    _reports = List.of(widget.reports);
  }

  Future<void> _add() async {
    final created = await showDialog<EcoReport>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _EcoReportDialog(place: widget.userSubDistrict),
    );
    if (created == null) return;
    setState(() => _reports = [created, ..._reports]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eko-Patrol / Czysta okolica')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.forest_outlined),
        label: const Text('Nowe zgłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Dzikie wysypiska, przepełnione kosze i drzewa w parku nad rzeką.',
          ),
          const SizedBox(height: 12),
          for (final report in _reports)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(switch (report.kind) {
                  EcoReportKind.dump => Icons.delete_outline,
                  EcoReportKind.overflowingBin => Icons.delete_sweep_outlined,
                  EcoReportKind.damagedTree => Icons.park_outlined,
                }),
                title: Text(report.title),
                subtitle: Text(
                  '${report.kind.label} · ${report.place}\n${report.description}',
                ),
                isThreeLine: true,
                trailing: report.status == EcoInterventionStatus.acceptedByOffice
                    ? const Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(Icons.verified_outlined, size: 16),
                        label: Text('Urząd / SM'),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _reports = _reports
                                .map(
                                  (item) => item.id == report.id
                                      ? item.copyWith(
                                          status: EcoInterventionStatus
                                              .acceptedByOffice,
                                        )
                                      : item,
                                )
                                .toList();
                          });
                          widget.onMarkAccepted(report.id);
                        },
                        child: const Text('Przyjęto'),
                      ),
              ),
            ),
          if (_reports.any(
            (item) => item.status == EcoInterventionStatus.acceptedByOffice,
          ))
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Chip(
                avatar: Icon(Icons.badge_outlined),
                label: Text('Zgłoszenie przyjęte przez urząd / SM'),
              ),
            ),
        ],
      ),
    );
  }
}

class _EcoReportDialog extends StatefulWidget {
  final String place;

  const _EcoReportDialog({required this.place});

  @override
  State<_EcoReportDialog> createState() => _EcoReportDialogState();
}

class _EcoReportDialogState extends State<_EcoReportDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  EcoReportKind _kind = EcoReportKind.dump;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie ekologiczne'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EcoReportKind>(
              initialValue: _kind,
              items: EcoReportKind.values
                  .map(
                    (kind) => DropdownMenuItem(
                      value: kind,
                      child: Text(kind.label),
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
              controller: _description,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Opis i lokalizacja'),
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
              EcoReport(
                id: 'eco-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                place: widget.place,
                description: _description.text.trim(),
                kind: _kind,
                createdAt: DateTime.now(),
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
