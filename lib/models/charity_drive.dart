enum CharityDriveKind { goods, money }

extension CharityDriveKindX on CharityDriveKind {
  String get label => switch (this) {
    CharityDriveKind.goods => 'Zbiórka rzeczowa',
    CharityDriveKind.money => 'Zbiórka finansowa',
  };
}

class CharityDrive {
  final String id;
  final String title;
  final String description;
  final CharityDriveKind kind;
  final int goal;
  final int collected;
  final String unit;
  final String beneficiary;

  const CharityDrive({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.goal,
    required this.collected,
    required this.unit,
    required this.beneficiary,
  });

  double get progress {
    if (goal <= 0) return 0;
    final ratio = collected / goal;
    if (ratio < 0) return 0;
    if (ratio > 1) return 1;
    return ratio;
  }

  CharityDrive copyWith({int? collected, int? goal}) {
    return CharityDrive(
      id: id,
      title: title,
      description: description,
      kind: kind,
      goal: goal ?? this.goal,
      collected: collected ?? this.collected,
      unit: unit,
      beneficiary: beneficiary,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'goal': goal,
    'collected': collected,
    'unit': unit,
    'beneficiary': beneficiary,
  };

  factory CharityDrive.fromJson(Map<String, dynamic> json) {
    return CharityDrive(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: CharityDriveKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CharityDriveKind.goods,
      ),
      goal: json['goal'] as int? ?? 1,
      collected: json['collected'] as int? ?? 0,
      unit: json['unit'] as String? ?? 'szt.',
      beneficiary: json['beneficiary'] as String? ?? 'Sąsiedzi',
    );
  }

  static List<CharityDrive> seeded() => const [
    CharityDrive(
      id: 'drive-karma',
      title: 'Karma dla zwierząt ze schroniska',
      description:
          'Mokra i sucha karma dla kotów i psów z lokalnego schroniska w okolicy.',
      kind: CharityDriveKind.goods,
      goal: 40,
      collected: 18,
      unit: 'kg',
      beneficiary: 'Schronisko / opiekunowie z osiedla',
    ),
    CharityDrive(
      id: 'drive-school',
      title: 'Wyprawka szkolna',
      description:
          'Plecaki, zeszyty i przybory dla dzieci z rodzin, które potrzebują wsparcia na start roku.',
      kind: CharityDriveKind.goods,
      goal: 12,
      collected: 5,
      unit: 'wyprawek',
      beneficiary: 'Rodziny z okolicy',
    ),
    CharityDrive(
      id: 'drive-heat',
      title: 'Zrzutka na opał i rachunki',
      description:
          'Celowa zbiórka finansowa dla sąsiadów, którzy nie wyrabiają się z ogrzewaniem.',
      kind: CharityDriveKind.money,
      goal: 1500,
      collected: 620,
      unit: 'zł',
      beneficiary: 'Sąsiedzka pomoc rodzinom',
    ),
  ];
}
