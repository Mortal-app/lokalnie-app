import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/flea_market_item.dart';

class FleaMarketScreen extends StatefulWidget {
  final List<FleaMarketItem> items;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<FleaMarketItem> onAdd;

  const FleaMarketScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<FleaMarketScreen> createState() => _FleaMarketScreenState();
}

class _FleaMarketScreenState extends State<FleaMarketScreen> {
  late List<FleaMarketItem> _items;
  FleaCategory? _category;
  FleaCondition? _condition;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  List<FleaMarketItem> get _visible => _items.where((item) {
    final matchesCategory = _category == null || item.category == _category;
    final matchesCondition =
        _condition == null || item.condition == _condition;
    return matchesCategory && matchesCondition;
  }).toList();

  Future<void> _add() async {
    final created = await showDialog<FleaMarketItem>(
      context: context,
      builder: (_) => _FleaDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokalny Targ Staroci')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.storefront_outlined),
        label: const Text('Wystaw rzecz'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Giełda kolekcjonera: winyle, stare gry, meble z duszą i rzadkie zbiory.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie kategorie'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final category in FleaCategory.values.take(2))
                FilterChip(
                  label: Text(category.label),
                  selected: _category == category,
                  onSelected: (_) => setState(
                    () => _category = _category == category ? null : category,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.category.label} · ${item.condition.label}\n'
                  '${item.price} · ${item.authorName}, ${item.subDistrict}\n'
                  '${item.description}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _FleaDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _FleaDialog({required this.userName, required this.subDistrict});

  @override
  State<_FleaDialog> createState() => _FleaDialogState();
}

class _FleaDialogState extends State<_FleaDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  var _category = FleaCategory.other;
  var _condition = FleaCondition.veryGood;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wystaw na targ staroci'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            DropdownButtonFormField<FleaCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategoria'),
              items: FleaCategory.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            DropdownButtonFormField<FleaCondition>(
              initialValue: _condition,
              decoration: const InputDecoration(labelText: 'Stan'),
              items: FleaCondition.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _condition = value);
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
              controller: _price,
              decoration: const InputDecoration(labelText: 'Cena / wymiana'),
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
              FleaMarketItem(
                id: 'flea-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                category: _category,
                condition: _condition,
                price: _price.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _price.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
              ),
            );
          },
          child: const Text('Wystaw'),
        ),
      ],
    );
  }
}
