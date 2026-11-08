import 'bike_station.dart';

enum StreetArtKind { mural, legalWall, install }

extension StreetArtKindX on StreetArtKind {
  String get label => switch (this) {
    StreetArtKind.mural => 'Mural',
    StreetArtKind.legalWall => 'Legalna ściana',
    StreetArtKind.install => 'Instalacja',
  };
}

class StreetArtSpot {
  final String id;
  final StreetArtKind kind;
  final String title;
  final String place;
  final String authorName;
  final StationAlign pos;

  const StreetArtSpot({
    required this.id,
    required this.kind,
    required this.title,
    required this.place,
    required this.authorName,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'place': place,
    'authorName': authorName,
    'pos': pos.name,
  };

  factory StreetArtSpot.fromJson(Map<String, dynamic> json) {
    return StreetArtSpot(
      id: json['id'] as String? ?? '',
      kind: StreetArtKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => StreetArtKind.mural,
      ),
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Mieszkaniec',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<StreetArtSpot> seeded() => const [
    StreetArtSpot(
      id: 'sa-mural',
      kind: StreetArtKind.mural,
      title: 'Mural na ścianie szczytowej',
      place: 'Widzew Wschód, przy Piłsudskiego',
      authorName: 'Klub foto',
      pos: StationAlign.topLeft,
    ),
    StreetArtSpot(
      id: 'sa-sciana',
      kind: StreetArtKind.legalWall,
      title: 'Legalna ściana grafficiarzy',
      place: 'Olechów, tył pawilonu',
      authorName: 'Arek',
      pos: StationAlign.bottomRight,
    ),
  ];
}
