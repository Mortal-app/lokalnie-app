import 'package:flutter/material.dart';

import '../models/digital_help.dart';

class DigitalHelpScreen extends StatefulWidget {
  final List<DigitalHelpOffer> items;
  final String userName;
  final ValueChanged<DigitalHelpOffer> onAdd;

  const DigitalHelpScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<DigitalHelpScreen> createState() => _DigitalHelpScreenState();
}

class _DigitalHelpScreenState extends State<DigitalHelpScreen> {
  late List<DigitalHelpOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<DigitalHelpOffer>(
      context: context,
      builder: (_) => _HelpDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank pomocy cyfrowej')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.smartphone_outlined),
        label: const Text('Oferuję pomoc'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Młodsi sąsiedzi pomagają seniorom: smartfon, profil zaufany, aplikacje miejskie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.support_agent_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenLabel}\n${item.helperName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _HelpDialog extends StatefulWidget {
  final String userName;

  const _HelpDialog({required this.userName});

  @override
  State<_HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<_HelpDialog> {
  final _title = TextEditingController();
  var _kind = DigitalHelpKind.smartphone;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pomoc cyfrowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<DigitalHelpKind>(
              initialValue: _kind,
              items: [
                for (final kind in DigitalHelpKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co oferujesz?'),
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
              DigitalHelpOffer(
                id: 'dh-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'Po umówieniu',
                helperName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
