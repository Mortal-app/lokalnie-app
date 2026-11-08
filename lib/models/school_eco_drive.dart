enum SchoolEcoKind { cans, caps, paper }

extension SchoolEcoKindX on SchoolEcoKind {
  String get label => switch (this) {
    SchoolEcoKind.cans => 'Puszki',
    SchoolEcoKind.caps => 'Nakrętki',
    SchoolEcoKind.paper => 'Makulatura',
  };
}

class SchoolEcoDrive {
  final String id;
  final SchoolEcoKind kind;
  final String school;
  final String title;
  final String whenLabel;

  const SchoolEcoDrive({
    required this.id,
    required this.kind,
    required this.school,
    required this.title,
    required this.whenLabel,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'school': school,
    'title': title,
    'whenLabel': whenLabel,
  };

  factory SchoolEcoDrive.fromJson(Map<String, dynamic> json) {
    return SchoolEcoDrive(
      id: json['id'] as String? ?? '',
      kind: SchoolEcoKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SchoolEcoKind.paper,
      ),
      school: json['school'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
    );
  }

  static List<SchoolEcoDrive> seeded() => const [
    SchoolEcoDrive(
      id: 'se-puszki',
      kind: SchoolEcoKind.cans,
      school: 'SP 141',
      title: 'Zbiórka puszek aluminiowych — klasy 1–3',
      whenLabel: 'Do 15.11, sekretariat',
    ),
    SchoolEcoDrive(
      id: 'se-nakr',
      kind: SchoolEcoKind.caps,
      school: 'SP 114',
      title: 'Nakrętki na wózek dla ucznia z Widzewa',
      whenLabel: 'Cały listopad',
    ),
    SchoolEcoDrive(
      id: 'se-mak',
      kind: SchoolEcoKind.paper,
      school: 'SP 34',
      title: 'Makulatura — worki przy portierni',
      whenLabel: 'Piątek 7:30–8:30',
    ),
  ];
}
