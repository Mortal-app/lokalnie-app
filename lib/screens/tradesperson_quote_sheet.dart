import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../services/app_image_picker.dart';
import '../theme/widzew_ui.dart';
import '../utils/submit_guard.dart';
import '../utils/utf8_text_guard.dart';

class TradespersonQuoteSheet extends StatefulWidget {
  final TradespersonListing listing;
  final String clientName;
  final ValueChanged<TradespersonJobRequest> onSubmit;

  const TradespersonQuoteSheet({
    super.key,
    required this.listing,
    required this.clientName,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required TradespersonListing listing,
    required String clientName,
    required ValueChanged<TradespersonJobRequest> onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => WidzewUi.barrierDismissibleSheet(
        context: sheetContext,
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(WidzewUi.radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: TradespersonQuoteSheet(
              listing: listing,
              clientName: clientName,
              onSubmit: (request) {
                onSubmit(request);
                Navigator.of(sheetContext).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<TradespersonQuoteSheet> createState() => _TradespersonQuoteSheetState();
}

class _TradespersonQuoteSheetState extends State<TradespersonQuoteSheet>
    with SubmitGuard {
  static const days = ['Dziś', 'Jutro', 'Weekend', 'Elastycznie'];

  final _problem = TextEditingController();
  final _details = TextEditingController();
  String _day = days.last;
  String? _photoPath;

  @override
  void dispose() {
    _problem.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path = await const AppImagePicker().pickFromGallery();
    if (path == null || !mounted) return;
    setState(() => _photoPath = path);
  }

  Future<void> _send() async {
    await runExclusive(() async {
      final problem = Utf8TextGuard.sanitize(_problem.text);
      if (problem.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opisz krótko problem do wyceny.')),
        );
        return;
      }
      final details = Utf8TextGuard.sanitize(_details.text);
      final buffer = StringBuffer()
        ..writeln('SZABLON WYCENY')
        ..writeln('Problem: $problem')
        ..writeln('Preferowany dzień: $_day');
      if (details.isNotEmpty) {
        buffer.writeln('Szczegóły: $details');
      }
      if (_photoPath != null) {
        buffer.writeln('Załączono zdjęcie realizacji / usterki.');
      }
      widget.onSubmit(
        TradespersonJobRequest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          listingId: widget.listing.id,
          tradespersonName: widget.listing.displayName,
          clientName: widget.clientName,
          title: 'Wycena: ${widget.listing.trade}',
          description: buffer.toString().trim(),
          clientPhone: '',
          createdAt: DateTime.now(),
          preferredDay: _day,
          photoPath: _photoPath ?? '',
          isQuote: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: WidzewUi.insetsWide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Poproś o wycenę',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text('Do: ${widget.listing.displayName} · ${widget.listing.trade}'),
            const SizedBox(height: 16),
            TextField(
              controller: _problem,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Krótki opis problemu',
                hintText: 'Np. cieknie spłuczka na klatce III',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(
                labelText: 'Preferowany dzień',
              ),
              items: [
                for (final day in days)
                  DropdownMenuItem(value: day, child: Text(day)),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _day = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _details,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Dodatkowy opis (opcjonalnie)',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(
                _photoPath == null ? 'Załącz zdjęcie' : 'Zdjęcie dodane',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: submitLocked ? null : _send,
              child: const Text('Wyślij zapytanie'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
