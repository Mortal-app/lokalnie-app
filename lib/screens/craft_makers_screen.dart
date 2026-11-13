import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/craft_maker.dart';
import '../theme/widzew_ui.dart';

class CraftMakersScreen extends StatefulWidget {
  final List<CraftMaker> makers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<CraftMaker> onAdd;

  const CraftMakersScreen({
    super.key,
    required this.makers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<CraftMakersScreen> createState() => _CraftMakersScreenState();
}

class _CraftMakersScreenState extends State<CraftMakersScreen> {
  late List<CraftMaker> _makers;

  @override
  void initState() {
    super.initState();
    _makers = List.of(widget.makers);
  }

  Future<void> _add() async {
    final created = await showDialog<CraftMaker>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _MakerDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _makers = [created, ..._makers]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rzemiosło i rękodzieło z Widzewa')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.handshake_outlined),
        label: const Text('Jestem lokalnym twórcą z Widzewa'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szydełkowanie, stolarstwo, wypieki i biżuteria od sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final maker in _makers)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(maker.name),
                subtitle: Text(
                  '${maker.kind.label} · ${maker.subDistrict}\n'
                  '${maker.description}'
                  '${maker.contact.isEmpty ? '' : '\nKontakt: ${maker.contact}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _MakerDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _MakerDialog({required this.userName, required this.subDistrict});

  @override
  State<_MakerDialog> createState() => _MakerDialogState();
}

class _MakerDialogState extends State<_MakerDialog> {
  final _description = TextEditingController();
  final _contact = TextEditingController();
  var _kind = CraftKind.crochet;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _description.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Jestem lokalnym twórcą z Widzewa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CraftKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rzemiosło'),
              items: CraftKind.values
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
              decoration: const InputDecoration(labelText: 'Co tworzysz'),
            ),
            TextField(
              controller: _contact,
              decoration: const InputDecoration(labelText: 'Kontakt'),
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
              CraftMaker(
                id: 'craft-${DateTime.now().microsecondsSinceEpoch}',
                name: widget.userName,
                kind: _kind,
                description: _description.text.trim().isEmpty
                    ? _kind.label
                    : _description.text.trim(),
                subDistrict: _subDistrict,
                contact: _contact.text.trim(),
              ),
            );
          },
          child: const Text('Zgłoś się'),
        ),
      ],
    );
  }
}
