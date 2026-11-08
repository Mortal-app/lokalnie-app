import 'dart:async';

import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/form_draft_store.dart';
import '../theme/widzew_colors.dart';

class SosAlertScreen extends StatefulWidget {
  final String initialSubDistrict;
  final String authorName;

  const SosAlertScreen({
    super.key,
    this.initialSubDistrict = 'Widzew Wschód',
    this.authorName = 'Sąsiad z Widzewa',
  });

  static const types = [
    'Zaginiony pies',
    'Zalanie',
    'Inne pilne',
  ];

  @override
  State<SosAlertScreen> createState() => _SosAlertScreenState();
}

class _SosAlertScreenState extends State<SosAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  String _type = SosAlertScreen.types.first;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.initialSubDistrict;
    final peek = FormDraftStore.peek(FormDraftStore.sosAlert);
    if (peek.isNotEmpty) {
      _detailsController.text = peek['description'] ?? '';
      final type = peek['type'];
      if (type != null && SosAlertScreen.types.contains(type)) {
        _type = type;
      }
    }
    _detailsController.addListener(() {
      FormDraftStore.save(FormDraftStore.sosAlert, {
        'description': _detailsController.text,
        'type': _type,
      });
    });
    unawaited(_restoreDraft());
  }

  Future<void> _restoreDraft() async {
    final draft = await FormDraftStore.load(FormDraftStore.sosAlert);
    if (!mounted || draft.isEmpty) return;
    setState(() {
      _detailsController.text = draft['description'] ?? _detailsController.text;
      final type = draft['type'];
      if (type != null && SosAlertScreen.types.contains(type)) {
        _type = type;
      }
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FormDraftStore.clear(FormDraftStore.sosAlert);
    Navigator.of(context).pop(
      Announcement(
        title: 'PILNE: $_type',
        category: Announcement.sosCategory,
        subDistrict: _subDistrict,
        time: 'Teraz',
        icon: Icons.sos,
        publishedAt: DateTime.now(),
        description: _detailsController.text.trim(),
        isMine: true,
        authorName: widget.authorName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        title: const Text('Alert SOS / PILNE'),
        backgroundColor: WidzewColors.red,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Card(
              color: Color(0xFFFFEBEE),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Zgłoszenie trafi na górę tablicy jako czerwony alert sąsiedzki. '
                  'Używaj tylko w sytuacjach pilnych.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: WidzewColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in SosAlertScreen.types)
                  ChoiceChip(
                    key: ValueKey('sos-type-$type'),
                    label: Text(type),
                    selected: _type == type,
                    selectedColor: WidzewColors.redSoft,
                    backgroundColor: WidzewColors.chipFill,
                    surfaceTintColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      color: WidzewColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() => _type = type);
                      FormDraftStore.save(FormDraftStore.sosAlert, {
                        'description': _detailsController.text,
                        'type': type,
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              dropdownColor: Colors.white,
              style: const TextStyle(color: WidzewColors.ink),
              decoration: const InputDecoration(
                labelText: 'Mikro-osiedle',
                labelStyle: TextStyle(color: WidzewColors.inkMuted),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              items: Announcement.subDistricts
                  .map(
                    (subDistrict) => DropdownMenuItem(
                      value: subDistrict,
                      child: Text(subDistrict),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _subDistrict = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailsController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                labelText: 'Co się dzieje?',
                labelStyle: TextStyle(color: Colors.white70),
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
              minLines: 3,
              maxLines: 5,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Opisz sytuację'
                  : null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: WidzewColors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: _submit,
            icon: const Icon(Icons.sos),
            label: const Text('Opublikuj alert SOS'),
          ),
        ),
      ),
    );
  }
}
