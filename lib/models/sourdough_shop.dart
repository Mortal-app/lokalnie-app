import 'bike_station.dart';

class SourdoughShop {
  final String id;
  final String name;
  final String place;
  final String note;
  final StationAlign pos;

  const SourdoughShop({
    required this.id,
    required this.name,
    required this.place,
    required this.note,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'note': note,
    'pos': pos.name,
  };

  factory SourdoughShop.fromJson(Map<String, dynamic> json) {
    return SourdoughShop(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<SourdoughShop> seeded() => const [
    SourdoughShop(
      id: 'ss-wsch',
      name: 'Piekarnia rzemieślnicza przy pętli',
      place: 'Widzew Wschód',
      note: 'Chleb na zakwasie, bez ulepszaczy — rano do 11:00.',
      pos: StationAlign.topLeft,
    ),
    SourdoughShop(
      id: 'ss-olech',
      name: 'Sklepik z pieczywem na zakwasie',
      place: 'Olechów, pawilon',
      note: 'Żytni i pszenny, lista wypieków na kartce w drzwiach.',
      pos: StationAlign.bottomRight,
    ),
  ];
}
