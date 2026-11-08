import 'package:flutter/material.dart';

import '../models/bulk_buy.dart';

class BulkBuyScreen extends StatefulWidget {
  final List<BulkBuy> buys;
  final ValueChanged<BulkBuy> onAdd;
  final ValueChanged<String> onToggleJoin;

  const BulkBuyScreen({
    super.key,
    required this.buys,
    required this.onAdd,
    required this.onToggleJoin,
  });

  @override
  State<BulkBuyScreen> createState() => _BulkBuyScreenState();
}

class _BulkBuyScreenState extends State<BulkBuyScreen> {
  late List<BulkBuy> _buys;

  @override
  void initState() {
    super.initState();
    _buys = List.of(widget.buys);
  }

  Future<void> _add() async {
    final created = await showDialog<BulkBuy>(
      context: context,
      builder: (_) => const _BulkDialog(),
    );
    if (created == null) return;
    setState(() => _buys = [created, ..._buys]);
    widget.onAdd(created);
  }

  void _join(BulkBuy buy) {
    final next = buy.toggleJoin();
    setState(() {
      _buys = _buys.map((item) => item.id == buy.id ? next : item).toList();
    });
    widget.onToggleJoin(buy.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wspólne zakupy hurtowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.groups_outlined),
        label: const Text('Nowe skrzykniecie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Pellet, ziemia, artykuły dziecięce — licznik chętnych i łączne zamówienie.',
          ),
          const SizedBox(height: 12),
          for (final buy in _buys)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buy.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Chętni: ${buy.joined} / ${buy.targetPeople}',
                    ),
                    Text(
                      'Łączne zamówienie: ${buy.totalOrder} ${buy.unit}',
                    ),
                    LinearProgressIndicator(
                      value: buy.targetPeople <= 0
                          ? 0
                          : (buy.joined / buy.targetPeople).clamp(0, 1),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _join(buy),
                        child: Text(
                          buy.iJoined ? 'Wypisz się' : 'Dołącz do zamówienia',
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

class _BulkDialog extends StatefulWidget {
  const _BulkDialog();

  @override
  State<_BulkDialog> createState() => _BulkDialogState();
}

class _BulkDialogState extends State<_BulkDialog> {
  final _title = TextEditingController();
  final _item = TextEditingController();
  final _unit = TextEditingController(text: 'kg');
  final _size = TextEditingController(text: '10');
  final _target = TextEditingController(text: '10');

  @override
  void dispose() {
    _title.dispose();
    _item.dispose();
    _unit.dispose();
    _size.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wspólne zamówienie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _item,
              decoration: const InputDecoration(labelText: 'Towar'),
            ),
            TextField(
              controller: _size,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Ilość na osobę'),
            ),
            TextField(
              controller: _unit,
              decoration: const InputDecoration(labelText: 'Jednostka'),
            ),
            TextField(
              controller: _target,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cel osób'),
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
              BulkBuy(
                id: 'bulk-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                item: _item.text.trim(),
                unitSize: int.tryParse(_size.text.trim()) ?? 1,
                unit: _unit.text.trim().isEmpty ? 'szt.' : _unit.text.trim(),
                joined: 1,
                targetPeople: int.tryParse(_target.text.trim()) ?? 10,
                iJoined: true,
              ),
            );
          },
          child: const Text('Utwórz'),
        ),
      ],
    );
  }
}
