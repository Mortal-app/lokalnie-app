import 'package:flutter/material.dart';

import '../models/market_stall.dart';
import '../theme/widzew_ui.dart';

class MarketStallsScreen extends StatefulWidget {
  final List<MarketStall> stalls;
  final String userName;
  final ValueChanged<MarketStall> onAdd;

  const MarketStallsScreen({
    super.key,
    required this.stalls,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<MarketStallsScreen> createState() => _MarketStallsScreenState();
}

class _MarketStallsScreenState extends State<MarketStallsScreen> {
  late List<MarketStall> _stalls;
  MarketWeekday? _day;

  @override
  void initState() {
    super.initState();
    _stalls = List.of(widget.stalls);
  }

  List<MarketStall> get _visible => _day == null
      ? _stalls
      : _stalls.where((item) => item.deliveryDay == _day).toList();

  Future<void> _add() async {
    final created = await showDialog<MarketStall>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _StallDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _stalls = [created, ..._stalls]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prosto z Ryneczku')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.storefront_outlined),
        label: const Text('Dodaj wystawcę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Rolnicy i wystawcy z Ryneczku Batory / Widzew: jaja, miody, warzywa. Filtr dnia dostawy.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie dni'),
                selected: _day == null,
                onSelected: (_) => setState(() => _day = null),
              ),
              for (final day in MarketWeekday.values.take(2))
                FilterChip(
                  label: Text(day.label),
                  selected: _day == day,
                  onSelected: (_) =>
                      setState(() => _day = _day == day ? null : day),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final stall in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.eco_outlined),
                title: Text(stall.name),
                subtitle: Text(
                  '${stall.offer}\n${stall.place} · dostawa: ${stall.deliveryDay.label}\n${stall.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _StallDialog extends StatefulWidget {
  final String userName;

  const _StallDialog({required this.userName});

  @override
  State<_StallDialog> createState() => _StallDialogState();
}

class _StallDialogState extends State<_StallDialog> {
  final _name = TextEditingController();
  final _offer = TextEditingController();
  var _day = MarketWeekday.saturday;

  @override
  void dispose() {
    _name.dispose();
    _offer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wystawca z ryneczku'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _offer,
              decoration: const InputDecoration(labelText: 'Oferta'),
            ),
            DropdownButtonFormField<MarketWeekday>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Dzień dostawy'),
              items: MarketWeekday.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _day = value);
              },
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
            if (_name.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              MarketStall(
                id: 'mkt-${DateTime.now().microsecondsSinceEpoch}',
                name: _name.text.trim(),
                offer: _offer.text.trim(),
                place: 'Ryneczek Batory / Widzew',
                deliveryDay: _day,
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
