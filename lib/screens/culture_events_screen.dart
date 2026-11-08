import 'package:flutter/material.dart';

import '../models/culture_event.dart';

class CultureEventsScreen extends StatefulWidget {
  final List<CultureEvent> events;
  final ValueChanged<String> onToggleInterested;
  final ValueChanged<CultureEvent> onAddToCalendar;

  const CultureEventsScreen({
    super.key,
    required this.events,
    required this.onToggleInterested,
    required this.onAddToCalendar,
  });

  @override
  State<CultureEventsScreen> createState() => _CultureEventsScreenState();
}

class _CultureEventsScreenState extends State<CultureEventsScreen> {
  late List<CultureEvent> _events;

  @override
  void initState() {
    super.initState();
    _events = List.of(widget.events);
  }

  void _interested(CultureEvent event) {
    setState(() {
      _events = _events
          .map(
            (item) => item.id == event.id
                ? item.copyWith(interested: !item.interested)
                : item,
          )
          .toList();
    });
    widget.onToggleInterested(event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kultura: DK Widzew / Fabryczka')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Koncerty, zajęcia dla dzieci i warsztaty w instytucjach kultury na Widzewie.',
          ),
          const SizedBox(height: 12),
          for (final event in _events)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${event.venue.label} · ${event.place}',
                    ),
                    Text(
                      '${event.startsAt.day}.${event.startsAt.month}.${event.startsAt.year} ${event.startsAt.hour.toString().padLeft(2, '0')}:${event.startsAt.minute.toString().padLeft(2, '0')}',
                    ),
                    Text(event.description),
                    if (event.forKids) const Chip(label: Text('Dla dzieci')),
                    if (event.isWorkshop) const Chip(label: Text('Warsztat')),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => widget.onAddToCalendar(event),
                          child: const Text('Zapisz w kalendarzu'),
                        ),
                        TextButton(
                          onPressed: () => _interested(event),
                          child: Text(
                            event.interested
                                ? 'Zapisano zainteresowanie'
                                : 'Interesuje mnie to',
                          ),
                        ),
                      ],
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
