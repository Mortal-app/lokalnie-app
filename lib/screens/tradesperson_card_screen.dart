import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/money_input.dart';
import '../utils/submit_guard.dart';

class TradespersonCardScreen extends StatefulWidget {
  final TradespersonCard initial;
  final ValueChanged<TradespersonCard> onSave;

  const TradespersonCardScreen({
    super.key,
    required this.initial,
    required this.onSave,
  });

  @override
  State<TradespersonCardScreen> createState() => _TradespersonCardScreenState();
}

class _TradespersonCardScreenState extends State<TradespersonCardScreen>
    with SubmitGuard {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _rate;
  late final TextEditingController _phone;
  late final TextEditingController _nip;
  late String _trade;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.displayName);
    _description = TextEditingController(text: widget.initial.description);
    _rate = TextEditingController(text: widget.initial.rateLabel);
    _phone = TextEditingController(text: widget.initial.phone);
    _nip = TextEditingController(text: widget.initial.nip);
    _trade = TradespersonTrade.values.contains(widget.initial.trade)
        ? widget.initial.trade
        : TradespersonTrade.values.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _rate.dispose();
    _phone.dispose();
    _nip.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await runExclusive(() async {
      final rateText = _rate.text.trim();
      final onlyAmount = RegExp(r'^[0-9.,\s]+$').hasMatch(rateText);
      if (onlyAmount && !MoneyInput.isValid(rateText)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(MoneyInput.errorText(rateText)!)),
        );
        return;
      }
      final card = TradespersonCard(
        displayName: _name.text.trim(),
        trade: _trade,
        description: _description.text.trim(),
        rateLabel: MoneyInput.isValid(rateText)
            ? MoneyInput.asRateLabel(rateText)
            : rateText,
        phone: _phone.text.trim(),
        nip: _nip.text.trim(),
      );
      if (!card.isComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uzupełnij nazwę, opis i stawkę wizytówki.'),
          ),
        );
        return;
      }
      widget.onSave(card);
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wizytówka fachowca')),
      body: ListView(
        padding: WidzewUi.insetsWide,
        children: [
          const Text(
            'Konto Fachowca (Złota Rączka) — te dane trafią do katalogu po opłaceniu abonamentu PRO.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nazwa firmy / imię',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _trade,
            decoration: const InputDecoration(labelText: 'Branża'),
            items: [
              for (final trade in TradespersonTrade.values)
                DropdownMenuItem(value: trade, child: Text(trade)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _trade = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Krótki opis oferty',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rate,
            keyboardType: MoneyInput.keyboard,
            inputFormatters: MoneyInput.formatters,
            decoration: const InputDecoration(
              labelText: 'Stawka (zł)',
              hintText: 'np. 120 lub 120,50',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Telefon (widoczny tylko przy aktywnym PRO)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nip,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'NIP firmy (weryfikacja NIP / dowód)',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: submitLocked ? null : _submit,
            child: const Text('Zapisz wizytówkę'),
          ),
        ],
      ),
    );
  }
}
