import 'package:flutter/material.dart';

import '../models/mall_carpool.dart';
import '../theme/widzew_ui.dart';

class MallCarpoolScreen extends StatefulWidget {
  final List<MallCarpoolRide> items;
  final String userName;
  final ValueChanged<MallCarpoolRide> onAdd;

  const MallCarpoolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<MallCarpoolScreen> createState() => _MallCarpoolScreenState();
}

class _MallCarpoolScreenState extends State<MallCarpoolScreen> {
  late List<MallCarpoolRide> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MallCarpoolRide>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _MallDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpooling do galerii')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Zabiorę sąsiada'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne wyjazdy do Tulipana, CH Batory i Castoramy — miejsce dla sąsiada bez auta.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text(item.mall.label),
                subtitle: Text(
                  '${item.whenText}\n${item.seats} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _MallDialog extends StatefulWidget {
  final String userName;

  const _MallDialog({required this.userName});

  @override
  State<_MallDialog> createState() => _MallDialogState();
}

class _MallDialogState extends State<_MallDialog> {
  var _mall = MallTarget.tulipan;
  final _when = TextEditingController();

  @override
  void dispose() {
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wyjazd na zakupy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<MallTarget>(
            initialValue: _mall,
            items: [
              for (final mall in MallTarget.values)
                DropdownMenuItem(value: mall, child: Text(mall.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _mall = value);
            },
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
          ),
        ],
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
              MallCarpoolRide(
                id: 'mc-${DateTime.now().millisecondsSinceEpoch}',
                mall: _mall,
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                seats: 'Miejsce dla sąsiada bez auta',
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
