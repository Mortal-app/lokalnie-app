import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/money_input.dart';

class TradespersonPriceListScreen extends StatelessWidget {
  final List<PriceListItem> items;
  final bool canEdit;
  final ValueChanged<PriceListItem>? onAdd;
  final ValueChanged<int>? onRemove;

  const TradespersonPriceListScreen({
    super.key,
    required this.items,
    this.canEdit = false,
    this.onAdd,
    this.onRemove,
  });

  Future<void> _add(BuildContext context) async {
    final created = await showDialog<PriceListItem>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const _PriceListItemDialog(),
    );
    if (created == null || !context.mounted) return;
    onAdd?.call(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orientacyjny Cennik')),
      floatingActionButton: WidzewUi.maybeSafeFab(
        canEdit
          ? FloatingActionButton.extended(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add),
              label: const Text('Dodaj stawkę'),
            )
          : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Stawki orientacyjne — dokładna wycena po oględzinach na Widzewie.',
          ),
          const SizedBox(height: 12),
          Card(
            child: items.isEmpty
                ? const Padding(
                    padding: WidzewUi.insetsWide,
                    child: Text('Brak pozycji. Dodaj usługi i stawki.'),
                  )
                : Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2.2),
                      1: FlexColumnWidth(1.2),
                      2: IntrinsicColumnWidth(),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Usługa',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Stawka',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox.shrink(),
                        ],
                      ),
                      for (var i = 0; i < items.length; i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(items[i].service),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(items[i].rate),
                            ),
                            canEdit
                                ? IconButton(
                                    tooltip: 'Usuń',
                                    onPressed: () => onRemove?.call(i),
                                    icon: const Icon(Icons.delete_outline),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PriceListItemDialog extends StatefulWidget {
  const _PriceListItemDialog();

  @override
  State<_PriceListItemDialog> createState() => _PriceListItemDialogState();
}

class _PriceListItemDialogState extends State<_PriceListItemDialog> {
  final _service = TextEditingController();
  final _rate = TextEditingController();
  var _saving = false;
  String? _rateError;

  @override
  void dispose() {
    _service.dispose();
    _rate.dispose();
    super.dispose();
  }

  void _submit() {
    if (_saving) return;
    final rateError = MoneyInput.errorText(_rate.text);
    if (_service.text.trim().isEmpty || rateError != null) {
      setState(() => _rateError = rateError ?? 'Podaj nazwę usługi.');
      return;
    }
    setState(() {
      _saving = true;
      _rateError = null;
    });
    Navigator.pop(
      context,
      PriceListItem(
        service: _service.text.trim(),
        rate: MoneyInput.asRateLabel(_rate.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pozycja cennika'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _service,
            decoration: const InputDecoration(labelText: 'Usługa'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _rate,
            keyboardType: MoneyInput.keyboard,
            inputFormatters: MoneyInput.formatters,
            decoration: InputDecoration(
              labelText: 'Stawka (zł)',
              hintText: 'np. 120 lub 120,50',
              errorText: _rateError,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
