enum AirportHub { modlin, okecie, lublinek }

extension AirportHubX on AirportHub {
  String get label => switch (this) {
    AirportHub.modlin => 'Modlin',
    AirportHub.okecie => 'Okęcie',
    AirportHub.lublinek => 'Łódź-Lublinek',
  };
}

class AirportRide {
  final String id;
  final AirportHub hub;
  final String whenText;
  final String costNote;
  final String authorName;

  const AirportRide({
    required this.id,
    required this.hub,
    required this.whenText,
    required this.costNote,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'hub': hub.name,
    'whenText': whenText,
    'costNote': costNote,
    'authorName': authorName,
  };

  factory AirportRide.fromJson(Map<String, dynamic> json) {
    return AirportRide(
      id: json['id'] as String? ?? '',
      hub: AirportHub.values.firstWhere(
        (item) => item.name == json['hub'],
        orElse: () => AirportHub.lublinek,
      ),
      whenText: json['whenText'] as String? ?? '',
      costNote: json['costNote'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<AirportRide> seeded() => const [
    AirportRide(
      id: 'ar-mod',
      hub: AirportHub.modlin,
      whenText: 'Piątek 4:30, zbiórka pętla Wschód',
      costNote: 'Dzielimy A1 i parking P1',
      authorName: 'Tomek',
    ),
    AirportRide(
      id: 'ar-lub',
      hub: AirportHub.lublinek,
      whenText: 'Niedziela 12:00',
      costNote: 'Połowa paliwa, bez autostrady',
      authorName: 'Kasia',
    ),
  ];
}
