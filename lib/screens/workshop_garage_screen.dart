import 'package:flutter/material.dart';

import '../models/workshop_tool.dart';
import '../theme/widzew_ui.dart';

class WorkshopGarageScreen extends StatefulWidget {
  final List<WorkshopTool> items;
  final ValueChanged<WorkshopTool> onAdd;
  final ValueChanged<String> onBorrow;

  const WorkshopGarageScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<WorkshopGarageScreen> createState() => _WorkshopGarageScreenState();
}

class _WorkshopGarageScreenState extends State<WorkshopGarageScreen> {
  late List<WorkshopTool> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WorkshopTool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _ToolDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(WorkshopTool item) {
    if (item.borrowed) return;
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(borrowed: true) : entry,
          )
          .toList();
    });
    widget.onBorrow(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garaż i stacja majsterkowicza')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.handyman_outlined),
        label: const Text('Udostępniam narzędzie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Klucze dynamometryczne, lutownice, spawarki i prostowniki — pasjonaci z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.build_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.owner}'),
                trailing: TextButton(
                  onPressed: item.borrowed ? null : () => _borrow(item),
                  child: Text(item.borrowed ? 'Wypożyczono' : 'Wypożycz'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolDialog extends StatefulWidget {
  const _ToolDialog();

  @override
  State<_ToolDialog> createState() => _ToolDialogState();
}

class _ToolDialogState extends State<_ToolDialog> {
  final _title = TextEditingController();
  var _kind = WorkshopToolKind.torque;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Narzędzie warsztatowe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WorkshopToolKind>(
              initialValue: _kind,
              items: [
                for (final kind in WorkshopToolKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
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
              WorkshopTool(
                id: 'wt-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                owner: 'Sąsiad',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
