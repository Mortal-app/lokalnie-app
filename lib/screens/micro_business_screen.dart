import 'package:flutter/material.dart';

import '../models/micro_business.dart';

class MicroBusinessScreen extends StatefulWidget {
  final List<MicroBusiness> items;
  final ValueChanged<MicroBusiness> onAdd;
  final void Function(String id, String review) onReview;

  const MicroBusinessScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onReview,
  });

  @override
  State<MicroBusinessScreen> createState() => _MicroBusinessScreenState();
}

class _MicroBusinessScreenState extends State<MicroBusinessScreen> {
  late List<MicroBusiness> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MicroBusiness>(
      context: context,
      builder: (_) => const _BizDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  Future<void> _review(MicroBusiness item) async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Opinia mieszkańca'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Krótka opinia'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.isEmpty) return;
    setState(() {
      _items = _items
          .map(
            (entry) => entry.id == item.id
                ? entry.copyWith(reviews: [...entry.reviews, text])
                : entry,
          )
          .toList();
    });
    widget.onReview(item.id, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inkubator mikrobiznesu')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.storefront_outlined),
        label: const Text('Dodaj działalność'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Jednoosobowe usługi z Widzewa: fryzjerka mobilna, kosmetyczka, elektryk, hydraulik — z opiniami sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(item.name),
                subtitle: Text(
                  '${item.kind.label} · ${item.area}\n${item.reviews.isEmpty ? 'Brak opinii' : item.reviews.join(' · ')}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => _review(item),
                  child: const Text('Opinia'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BizDialog extends StatefulWidget {
  const _BizDialog();

  @override
  State<_BizDialog> createState() => _BizDialogState();
}

class _BizDialogState extends State<_BizDialog> {
  final _name = TextEditingController();
  var _kind = MicroBizKind.hair;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Działalność'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<MicroBizKind>(
              initialValue: _kind,
              items: [
                for (final kind in MicroBizKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nazwa / imię'),
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
              MicroBusiness(
                id: 'mb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                name: _name.text.trim().isEmpty
                    ? _kind.label
                    : _name.text.trim(),
                area: 'Widzew',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
