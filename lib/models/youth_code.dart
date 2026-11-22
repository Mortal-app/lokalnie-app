enum YouthCodeKind { coding, robot, print3d }

extension YouthCodeKindX on YouthCodeKind {
  String get label => switch (this) {
    YouthCodeKind.coding => 'Kodowanie',
    YouthCodeKind.robot => 'Robotyka',
    YouthCodeKind.print3d => 'Druk 3D',
  };
}

class YouthCodeWorkshop {
  final String id;
  final YouthCodeKind kind;
  final String title;
  final String place;
  final String whenLabel;
  final String host;

  const YouthCodeWorkshop({
    required this.id,
    required this.kind,
    required this.title,
    required this.place,
    required this.whenLabel,
    required this.host,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'place': place,
    'whenLabel': whenLabel,
    'host': host,
  };

  factory YouthCodeWorkshop.fromJson(Map<String, dynamic> json) {
    return YouthCodeWorkshop(
      id: json['id'] as String? ?? '',
      kind: YouthCodeKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => YouthCodeKind.coding,
      ),
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Okolica',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Prowadzący',
    );
  }

  static List<YouthCodeWorkshop> seeded() => const [
    YouthCodeWorkshop(
      id: 'yc-kod',
      kind: YouthCodeKind.coding,
      title: 'Scratch i pierwsze pętle — klasy 4–6',
      place: 'Świetlica szkoła podstawowa',
      whenLabel: 'Środa 16:30',
      host: 'Klub młodego programisty',
    ),
    YouthCodeWorkshop(
      id: 'yc-3d',
      kind: YouthCodeKind.print3d,
      title: 'Podstawy druku 3D — breloczki',
      place: 'okolica, klub osiedlowy',
      whenLabel: 'Sobota 11:00',
      host: 'Bartek',
    ),
  ];
}
