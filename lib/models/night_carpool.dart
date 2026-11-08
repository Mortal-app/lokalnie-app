enum NightRideKind { nightReturn, weekendTrip }

extension NightRideKindX on NightRideKind {
  String get label => switch (this) {
    NightRideKind.nightReturn => 'Powrót z centrum (noc)',
    NightRideKind.weekendTrip => 'Weekend poza miasto',
  };
}

class NightCarpoolRide {
  final String id;
  final NightRideKind kind;
  final String title;
  final String whenLabel;
  final String authorName;
  final int seats;

  const NightCarpoolRide({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.authorName,
    this.seats = 2,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'authorName': authorName,
    'seats': seats,
  };

  factory NightCarpoolRide.fromJson(Map<String, dynamic> json) {
    return NightCarpoolRide(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == NightRideKind.weekendTrip.name
          ? NightRideKind.weekendTrip
          : NightRideKind.nightReturn,
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
      seats: json['seats'] as int? ?? 2,
    );
  }

  static List<NightCarpoolRide> seeded() => const [
    NightCarpoolRide(
      id: 'nc-noc',
      kind: NightRideKind.nightReturn,
      title: 'Po imprezie z Piotrkowskiej → Olechów',
      whenLabel: 'Sobota ~1:30',
      authorName: 'Tomek',
      seats: 3,
    ),
    NightCarpoolRide(
      id: 'nc-wknd',
      kind: NightRideKind.weekendTrip,
      title: 'Weekend nad Zalewem Sulejowskim',
      whenLabel: 'Niedziela 9:00, klatka II',
      authorName: 'Kasia',
      seats: 2,
    ),
  ];
}
