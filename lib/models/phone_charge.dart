import 'bike_station.dart';

class PhoneChargeHub {
  final String id;
  final String name;
  final String place;
  final String note;
  final StationAlign pos;

  const PhoneChargeHub({
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

  factory PhoneChargeHub.fromJson(Map<String, dynamic> json) {
    return PhoneChargeHub(
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

  static List<PhoneChargeHub> seeded() => const [
    PhoneChargeHub(
      id: 'pc-bibl',
      name: 'Biblioteka w Twojej okolicy',
      place: 'Czytelnia — gniazdka przy stolikach',
      note: 'Awaryjne ładowanie telefonu, cisza.',
      pos: StationAlign.topLeft,
    ),
    PhoneChargeHub(
      id: 'pc-dk',
      name: 'Dom kultury',
      place: 'Hol domu kultury',
      note: 'Powerbank miejski / USB przy recepcji w godzinach otwarcia.',
      pos: StationAlign.bottomRight,
    ),
  ];
}
