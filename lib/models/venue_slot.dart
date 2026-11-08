class VenueSlot {
  final String id;
  final String venue;
  final String weekday;
  final String hour;
  final String reservedBy;

  const VenueSlot({
    required this.id,
    required this.venue,
    required this.weekday,
    required this.hour,
    this.reservedBy = '',
  });

  bool get isFree => reservedBy.isEmpty;

  VenueSlot copyWith({String? reservedBy}) {
    return VenueSlot(
      id: id,
      venue: venue,
      weekday: weekday,
      hour: hour,
      reservedBy: reservedBy ?? this.reservedBy,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'venue': venue,
    'weekday': weekday,
    'hour': hour,
    'reservedBy': reservedBy,
  };

  factory VenueSlot.fromJson(Map<String, dynamic> json) {
    return VenueSlot(
      id: json['id'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      weekday: json['weekday'] as String? ?? 'Poniedziałek',
      hour: json['hour'] as String? ?? '18:00',
      reservedBy: json['reservedBy'] as String? ?? '',
    );
  }

  static const venues = [
    'Boisko Orlik',
    'Stół do ping-ponga',
    'Sala osiedlowa',
  ];

  static const weekdays = [
    'Poniedziałek',
    'Wtorek',
    'Środa',
    'Czwartek',
    'Piątek',
  ];

  static const hours = ['16:00', '17:00', '18:00', '19:00', '20:00'];

  static List<VenueSlot> seeded() {
    final slots = <VenueSlot>[];
    var index = 0;
    for (final venue in venues) {
      for (final day in weekdays) {
        for (final hour in hours) {
          index++;
          slots.add(
            VenueSlot(
              id: 'slot-$index',
              venue: venue,
              weekday: day,
              hour: hour,
              reservedBy: index == 8 || index == 22 ? 'Klub biegaczy' : '',
            ),
          );
        }
      }
    }
    return slots;
  }
}
