import 'package:flutter/material.dart';

import '../models/staircase_fund.dart';
import '../theme/widzew_ui.dart';

class StaircaseFundScreen extends StatefulWidget {
  final List<StaircaseFund> funds;
  final String userName;
  final ValueChanged<StaircaseFund> onAdd;
  final void Function(String id, StaircasePayment payment) onPay;

  const StaircaseFundScreen({
    super.key,
    required this.funds,
    required this.userName,
    required this.onAdd,
    required this.onPay,
  });

  @override
  State<StaircaseFundScreen> createState() => _StaircaseFundScreenState();
}

class _StaircaseFundScreenState extends State<StaircaseFundScreen> {
  late List<StaircaseFund> _funds;

  @override
  void initState() {
    super.initState();
    _funds = List.of(widget.funds);
  }

  Future<void> _add() async {
    final created = await showDialog<StaircaseFund>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _FundDialog(),
    );
    if (created == null) return;
    setState(() => _funds = [created, ..._funds]);
    widget.onAdd(created);
  }

  Future<void> _pay(StaircaseFund fund) async {
    final amount = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _PayDialog(),
    );
    if (amount == null || amount <= 0) return;
    final payment = StaircasePayment(payer: widget.userName, amount: amount);
    setState(() {
      _funds = _funds
          .map(
            (item) => item.id == fund.id
                ? item.copyWith(payments: [...item.payments, payment])
                : item,
          )
          .toList();
    });
    widget.onPay(fund.id, payment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skrzynka finansowa klatki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.savings_outlined),
        label: const Text('Nowa składka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Kwiaty, żarówki, sprzątanie — lista wpłat i podsumowanie klatki.',
          ),
          const SizedBox(height: 12),
          for (final fund in _funds)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Zebrano ${fund.collected} / ${fund.goal} zł',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    LinearProgressIndicator(
                      value: fund.goal <= 0
                          ? 0
                          : (fund.collected / fund.goal).clamp(0, 1),
                    ),
                    const SizedBox(height: 8),
                    for (final payment in fund.payments)
                      Text('${payment.payer}: ${payment.amount} zł'),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _pay(fund),
                        child: const Text('Dodaj wpłatę'),
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

class _FundDialog extends StatefulWidget {
  const _FundDialog();

  @override
  State<_FundDialog> createState() => _FundDialogState();
}

class _FundDialogState extends State<_FundDialog> {
  final _title = TextEditingController();
  final _goal = TextEditingController(text: '100');

  @override
  void dispose() {
    _title.dispose();
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa składka klatkowa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Na co'),
          ),
          TextField(
            controller: _goal,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cel (zł)'),
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              StaircaseFund(
                id: 'fund-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                goal: int.tryParse(_goal.text.trim()) ?? 0,
              ),
            );
          },
          child: const Text('Utwórz'),
        ),
      ],
    );
  }
}

class _PayDialog extends StatefulWidget {
  const _PayDialog();

  @override
  State<_PayDialog> createState() => _PayDialogState();
}

class _PayDialogState extends State<_PayDialog> {
  final _amount = TextEditingController(text: '20');

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wpłata'),
      content: TextField(
        controller: _amount,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Kwota (zł)'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, int.tryParse(_amount.text.trim()) ?? 0),
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
