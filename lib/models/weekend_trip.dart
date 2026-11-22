enum WeekendTripKind { coach, bike }

extension WeekendTripKindX on WeekendTripKind {
  String get label => switch (this) {
    WeekendTripKind.coach => 'Autokar',
    WeekendTripKind.bike => 'Rower',
  };
}

class WeekendTrip {
  final String id;
  final WeekendTripKind kind;
  final String title;
  final String destination;
  final String whenLabel;
  final String host;
  final int going;

  const WeekendTrip({
    required this.id,
    required this.kind,
    required this.title,
    required this.destination,
    required this.whenLabel,
    required this.host,
    this.going = 1,
  });

  WeekendTrip copyWith({int? going}) {
    return WeekendTrip(
      id: id,
      kind: kind,
      title: title,
      destination: destination,
      whenLabel: whenLabel,
      host: host,
      going: going ?? this.going,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'destination': destination,
    'whenLabel': whenLabel,
    'host': host,
    'going': going,
  };

  factory WeekendTrip.fromJson(Map<String, dynamic> json) {
    return WeekendTrip(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == WeekendTripKind.bike.name
          ? WeekendTripKind.bike
          : WeekendTripKind.coach,
      title: json['title'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Organizator',
      going: json['going'] as int? ?? 1,
    );
  }

  static List<WeekendTrip> seeded() => const [
    WeekendTrip(
      id: 'wt-mokra',
      kind: WeekendTripKind.bike,
      title: 'Rezerwat Mokra Lewa',
      destination: 'Mokra Lewa',
      whenLabel: 'Sobota 8:00, zbiórka centrum handlowe',
      host: 'Klub turystyki',
      going: 7,
    ),
    WeekendTrip(
      id: 'wt-sulej',
      kind: WeekendTripKind.coach,
      title: 'Zalew Sulejowski — dzień nad wodą',
      destination: 'Zalew Sulejowski',
      whenLabel: 'Niedziela 7:30',
      host: 'Kasia',
      going: 12,
    ),
    WeekendTrip(
      id: 'wt-lag',
      kind: WeekendTripKind.bike,
      title: 'Las okolicy — pętla',
      destination: 'lasy',
      whenLabel: 'Sobota 9:00',
      host: 'Bartek',
      going: 5,
    ),
  ];
}
