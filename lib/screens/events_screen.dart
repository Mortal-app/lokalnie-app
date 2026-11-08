import 'package:flutter/material.dart';

import '../models/neighborhood_event.dart';
import '../theme/widzew_colors.dart';

class EventsScreen extends StatefulWidget {
  final List<NeighborhoodEvent> events;
  final ValueChanged<String> onToggleGoing;
  final ValueChanged<NeighborhoodEvent> onAddToCalendar;
  final ValueChanged<NeighborhoodEvent>? onRemindTomorrow;

  const EventsScreen({
    super.key,
    required this.events,
    required this.onToggleGoing,
    required this.onAddToCalendar,
    this.onRemindTomorrow,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late List<NeighborhoodEvent> _events;

  @override
  void initState() {
    super.initState();
    _events = List.of(widget.events);
  }

  String _format(DateTime dateTime) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(dateTime.day)}.${two(dateTime.month)}.${dateTime.year}, '
        '${two(dateTime.hour)}:${two(dateTime.minute)}';
  }

  void _toggle(String id) {
    widget.onToggleGoing(id);
    setState(() {
      final index = _events.indexWhere((event) => event.id == id);
      if (index == -1) return;
      _events[index] = _events[index].toggleGoing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wydarzenia na Widzewie')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: _events.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text('${_format(event.startsAt)} · ${event.place}'),
                  const SizedBox(height: 8),
                  Text(event.description),
                  const SizedBox(height: 8),
                  Text('${event.goingCount} sąsiadów: Wybieram się'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.tonal(
                        key: ValueKey('event-going-${event.id}'),
                        onPressed: () => _toggle(event.id),
                        child: Text(
                          event.isGoing ? 'Wypisuję się' : 'Wybieram się',
                        ),
                      ),
                      OutlinedButton.icon(
                        key: ValueKey('event-calendar-${event.id}'),
                        onPressed: () => widget.onAddToCalendar(event),
                        icon: const Icon(Icons.calendar_month_outlined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: WidzewColors.red,
                        ),
                        label: const Text('Dodaj do kalendarza'),
                      ),
                      if (widget.onRemindTomorrow != null)
                        TextButton.icon(
                          onPressed: () =>
                              widget.onRemindTomorrow!(event),
                          icon: const Icon(Icons.alarm_add_outlined),
                          label: const Text('Przypomnij mi jutro'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
