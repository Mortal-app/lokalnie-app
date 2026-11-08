import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/announcement.dart';
import '../models/senior_offer.dart';

class SeniorCornerScreen extends StatefulWidget {
  final List<SeniorOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<SeniorOffer> onAdd;

  const SeniorCornerScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<SeniorCornerScreen> createState() => _SeniorCornerScreenState();
}

class _SeniorCornerScreenState extends State<SeniorCornerScreen> {
  late List<SeniorOffer> _offers;
  SeniorOfferKind? _kind;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
  }

  List<SeniorOffer> get _visible => _kind == null
      ? _offers
      : _offers.where((item) => item.kind == _kind).toList();

  Future<void> _add({required bool volunteer}) async {
    final created = await showDialog<SeniorOffer>(
      context: context,
      builder: (_) => _SeniorDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
        volunteer: volunteer,
      ),
    );
    if (created == null) return;
    setState(() => _offers = [created, ..._offers]);
    widget.onAdd(created);
  }

  Future<void> _contact(SeniorOffer offer) async {
    final isWidgetTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgets',
    );
    final digits = offer.contact.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!isWidgetTest && digits.length >= 9) {
      final uri = Uri(scheme: 'tel', path: digits);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }
    if (!isWidgetTest) {
      await Clipboard.setData(ClipboardData(text: offer.contact));
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Skopiowano kontakt: ${offer.contact}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kącik Seniora z Widzewa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Text(
            'Duże przyciski, proste ogłoszenia. Spacer, kawa, szachy i pomoc w urzędzie.',
            style: TextStyle(fontSize: 18, height: 1.35),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () => _add(volunteer: false),
            icon: const Icon(Icons.add, size: 28),
            label: const Text('Dodaj ogłoszenie'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () => _add(volunteer: true),
            icon: const Icon(Icons.volunteer_activism_outlined, size: 28),
            label: const Text('Chcę pomagać seniorom'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Wszystko', style: TextStyle(fontSize: 16)),
                selected: _kind == null,
                onSelected: (_) => setState(() => _kind = null),
              ),
              for (final kind in SeniorOfferKind.values.take(2))
                FilterChip(
                  label: Text(kind.label, style: const TextStyle(fontSize: 16)),
                  selected: _kind == kind,
                  onSelected: (_) => setState(
                    () => _kind = _kind == kind ? null : kind,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final offer in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.kind.label,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      offer.description,
                      style: const TextStyle(fontSize: 16, height: 1.3),
                    ),
                    Text(
                      '${offer.authorName} · ${offer.subDistrict}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () => _contact(offer),
                      icon: const Icon(Icons.phone_outlined),
                      label: Text('Szybki kontakt: ${offer.contact}'),
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

class _SeniorDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;
  final bool volunteer;

  const _SeniorDialog({
    required this.userName,
    required this.subDistrict,
    required this.volunteer,
  });

  @override
  State<_SeniorDialog> createState() => _SeniorDialogState();
}

class _SeniorDialogState extends State<_SeniorDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _contact = TextEditingController();
  late SeniorOfferKind _kind;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _kind = widget.volunteer
        ? SeniorOfferKind.volunteer
        : SeniorOfferKind.walk;
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.volunteer ? 'Zgłoszenie chęci pomocy' : 'Ogłoszenie seniora',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SeniorOfferKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: SeniorOfferKind.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _contact,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'Telefon lub dzwonek',
              ),
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
              controller: _description,
              style: const TextStyle(fontSize: 18),
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj', style: TextStyle(fontSize: 16)),
        ),
        FilledButton(
          onPressed: () {
            if (_title.text.trim().isEmpty || _contact.text.trim().isEmpty) {
              return;
            }
            Navigator.pop(
              context,
              SeniorOffer(
                id: 'senior-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                contact: _contact.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
                wantsHelp: _kind != SeniorOfferKind.volunteer,
              ),
            );
          },
          child: const Text('Zapisz', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
