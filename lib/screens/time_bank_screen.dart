import 'package:flutter/material.dart';

import '../models/time_bank_offer.dart';
import '../theme/widzew_ui.dart';

class TimeBankScreen extends StatefulWidget {
  final List<TimeBankOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final int timeBankHours;
  final ValueChanged<TimeBankOffer> onAdd;
  final ValueChanged<String> onComplete;

  const TimeBankScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.timeBankHours,
    required this.onAdd,
    required this.onComplete,
  });

  @override
  State<TimeBankScreen> createState() => _TimeBankScreenState();
}

class _TimeBankScreenState extends State<TimeBankScreen> {
  late List<TimeBankOffer> _offers;
  late int _hours;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
    _hours = widget.timeBankHours;
  }

  Future<void> _add() async {
    final created = await showDialog<TimeBankOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TimeOfferDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _offers = [created, ..._offers]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sąsiedzki Bank Czasu')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.schedule_outlined),
        label: const Text('Dodaj przysługę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.hourglass_bottom),
              title: Text('Twoje godziny pomocy: $_hours h'),
              subtitle: const Text(
                'Punkty banku czasu naliczane za zrealizowane przysługi.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wymiana oparta na czasie: korepetycje za trawnik, wniesienie pralki, drobne przysługi.',
          ),
          const SizedBox(height: 12),
          for (final offer in _offers)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(offer.isNeed ? offer.want : offer.offer),
                    Text(
                      offer.isNeed
                          ? 'W zamian: ${offer.offer}'
                          : 'W zamian za: ${offer.want}',
                    ),
                    Text(
                      '${offer.hours} h · ${offer.authorName} · ${offer.subDistrict}',
                    ),
                    if (offer.isCompleted)
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text('Zrealizowane'),
                      )
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _hours += offer.hours;
                              _offers = _offers
                                  .map(
                                    (item) => item.id == offer.id
                                        ? item.copyWith(isCompleted: true)
                                        : item,
                                  )
                                  .toList();
                            });
                            widget.onComplete(offer.id);
                          },
                          child: const Text('Zalicz godziny'),
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

class _TimeOfferDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _TimeOfferDialog({
    required this.userName,
    required this.subDistrict,
  });

  @override
  State<_TimeOfferDialog> createState() => _TimeOfferDialogState();
}

class _TimeOfferDialogState extends State<_TimeOfferDialog> {
  final _title = TextEditingController();
  final _offer = TextEditingController();
  final _want = TextEditingController();
  var _hours = 1;
  var _isNeed = false;

  @override
  void dispose() {
    _title.dispose();
    _offer.dispose();
    _want.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa przysługa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Szukam pomocy'),
              value: _isNeed,
              onChanged: (value) => setState(() => _isNeed = value),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _offer,
              decoration: InputDecoration(
                labelText: _isNeed ? 'Czym się odwdzięczę' : 'Co oferuję',
              ),
            ),
            TextField(
              controller: _want,
              decoration: InputDecoration(
                labelText: _isNeed ? 'Czego potrzebuję' : 'Czego szukam w zamian',
              ),
            ),
            DropdownButtonFormField<int>(
              initialValue: _hours,
              decoration: const InputDecoration(labelText: 'Godziny'),
              items: const [1, 2, 3]
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text('$item h'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _hours = value);
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              TimeBankOffer(
                id: 'tb-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                offer: _offer.text.trim(),
                want: _want.text.trim(),
                hours: _hours,
                authorName: widget.userName,
                subDistrict: widget.subDistrict,
                isNeed: _isNeed,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
