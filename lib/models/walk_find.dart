import 'bike_station.dart';

class WalkFindReport {
  final String id;
  final String title;
  final String place;
  final String photoNote;
  final String authorName;
  final StationAlign pos;

  const WalkFindReport({
    required this.id,
    required this.title,
    required this.place,
    required this.photoNote,
    required this.authorName,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'photoNote': photoNote,
    'authorName': authorName,
    'pos': pos.name,
  };

  factory WalkFindReport.fromJson(Map<String, dynamic> json) {
    return WalkFindReport(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      photoNote: json['photoNote'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<WalkFindReport> seeded() => const [
    WalkFindReport(
      id: 'wf-klucze',
      title: 'Znalazłem pęk kluczy przy wejściu do parku',
      place: 'Wejście do parku, osiedle wschodnie',
      photoNote: 'Zdjęcie: pęk z brelokiem w kształcie piłki.',
      authorName: 'Arek',
      pos: StationAlign.topLeft,
    ),
    WalkFindReport(
      id: 'wf-rekaw',
      title: 'Rękawiczka dziecięca na ławce',
      place: 'Aleja w parku przy Janowie',
      photoNote: 'Zdjęcie: czerwona rękawiczka, rozmiar ok. 5–7 lat.',
      authorName: 'Hania',
      pos: StationAlign.bottomRight,
    ),
  ];
}
