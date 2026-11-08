import 'package:flutter/material.dart';

import '../models/venue_slot.dart';

class VenueBookingScreen extends StatefulWidget {
  final List<VenueSlot> slots;
  final String userName;
  final void Function(String id, String reservedBy) onReserve;

  const VenueBookingScreen({
    super.key,
    required this.slots,
    required this.userName,
    required this.onReserve,
  });

  @override
  State<VenueBookingScreen> createState() => _VenueBookingScreenState();
}

class _VenueBookingScreenState extends State<VenueBookingScreen> {
  late List<VenueSlot> _slots;
  var _venue = VenueSlot.venues.first;

  @override
  void initState() {
    super.initState();
    _slots = List.of(widget.slots);
  }

  List<VenueSlot> get _forVenue =>
      _slots.where((item) => item.venue == _venue).toList();

  void _book(VenueSlot slot) {
    if (!slot.isFree) return;
    setState(() {
      _slots = _slots
          .map(
            (item) => item.id == slot.id
                ? item.copyWith(reservedBy: widget.userName)
                : item,
          )
          .toList();
    });
    widget.onReserve(slot.id, widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grafik boisk i sal')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Zajętość Orlika, ping-ponga i sali osiedlowej. Kalendarz godzinowy — tapnij wolny slot.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final venue in VenueSlot.venues.take(3))
                ChoiceChip(
                  label: Text(venue),
                  selected: _venue == venue,
                  onSelected: (_) => setState(() => _venue = venue),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final day in VenueSlot.weekdays) ...[
            Text(day, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final slot in _forVenue.where((item) => item.weekday == day))
                  FilterChip(
                    label: Text(
                      slot.isFree ? slot.hour : '${slot.hour} zajęte',
                    ),
                    selected: !slot.isFree,
                    onSelected: slot.isFree ? (_) => _book(slot) : null,
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
