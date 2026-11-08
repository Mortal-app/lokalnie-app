import 'package:flutter/material.dart';

import '../models/cost_split.dart';

class CostSplitScreen extends StatefulWidget {
  final List<CostSplit> items;
  final ValueChanged<CostSplit> onAdd;

  const CostSplitScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<CostSplitScreen> createState() => _CostSplitScreenState();
}

class _CostSplitScreenState extends State<CostSplitScreen> {
  late List<CostSplit> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CostSplit>(
      context: context,
      builder: (_) => const _SplitDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podział kosztów i rozliczenia')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.receipt_long_outlined),
        label: const Text('Nowe rozliczenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Transport, materiały budowlane i imprezy osiedlowe — podsumowanie na kartę.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(item.kind.label),
                    const SizedBox(height: 8),
                    Text(item.summary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SplitDialog extends StatefulWidget {
  const _SplitDialog();

  @override
  State<_SplitDialog> createState() => _SplitDialogState();
}

class _SplitDialogState extends State<_SplitDialog> {
  final _title = TextEditingController();
  final _total = TextEditingController();
  final _people = TextEditingController(text: '2');
  final _note = TextEditingController();
  var _kind = CostSplitKind.party;
  String? _preview;

  @override
  void dispose() {
    _title.dispose();
    _total.dispose();
    _people.dispose();
    _note.dispose();
    super.dispose();
  }

  CostSplit? _build() {
    final total = double.tryParse(_total.text.trim().replaceAll(',', '.'));
    final people = int.tryParse(_people.text.trim());
    if (total == null || total <= 0 || people == null || people < 1) {
      return null;
    }
    return CostSplit(
      id: 'split-${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim().isEmpty ? _kind.label : _title.text.trim(),
      kind: _kind,
      total: total,
      people: people,
      note: _note.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rozliczenie sąsiedzkie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CostSplitKind>(
              initialValue: _kind,
              items: [
                for (final kind in CostSplitKind.values)
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
            TextField(
              controller: _total,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Kwota razem (zł)'),
            ),
            TextField(
              controller: _people,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Liczba osób'),
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Notatka'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                final split = _build();
                setState(() => _preview = split?.summary ?? 'Podaj kwotę i liczbę osób.');
              },
              child: const Text('Generuj podsumowanie'),
            ),
            if (_preview != null) Text(_preview!),
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
            final split = _build();
            if (split == null) return;
            Navigator.pop(context, split);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
