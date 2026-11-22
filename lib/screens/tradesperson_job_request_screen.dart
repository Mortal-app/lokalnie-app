import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/submit_guard.dart';
import '../utils/utf8_text_guard.dart';

class TradespersonJobRequestScreen extends StatefulWidget {
  final TradespersonListing listing;
  final String clientName;
  final ValueChanged<TradespersonJobRequest> onSubmit;

  const TradespersonJobRequestScreen({
    super.key,
    required this.listing,
    required this.clientName,
    required this.onSubmit,
  });

  @override
  State<TradespersonJobRequestScreen> createState() =>
      _TradespersonJobRequestScreenState();
}

class _TradespersonJobRequestScreenState
    extends State<TradespersonJobRequestScreen>
    with SubmitGuard {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text: 'Zlecenie: ${widget.listing.trade}',
    );
    _description = TextEditingController();
    _phone = TextEditingController();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await runExclusive(() async {
      final title = Utf8TextGuard.sanitize(_title.text);
      final description = Utf8TextGuard.sanitize(_description.text);
      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uzupełnij temat i opis zlecenia.')),
        );
        return;
      }
      widget.onSubmit(
        TradespersonJobRequest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          listingId: widget.listing.id,
          tradespersonName: widget.listing.displayName,
          clientName: widget.clientName,
          title: title,
          description: description,
          clientPhone: _phone.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zlecenie wewnętrzne')),
      body: ListView(
        padding: WidzewUi.insetsWide.copyWith(bottom: WidzewUi.fabScrollBottom),
        children: [
          Text(
            'Zapytanie do: ${widget.listing.displayName}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Numer fachowca pozostaje ukryty. Zlecenie idzie przez aplikację, bez odpływu kontaktów poza Lokalnie.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Temat zlecenia'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Opis prac (adres klatki, termin, zakres)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Twój telefon zwrotny (opcjonalnie)',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: submitLocked ? null : _submit,
            child: const Text('Wyślij zlecenie'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
