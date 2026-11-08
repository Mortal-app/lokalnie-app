enum PowerShareKind { generator, powerbank, headlamp }

extension PowerShareKindX on PowerShareKind {
  String get label => switch (this) {
    PowerShareKind.generator => 'Agregat prądotwórczy',
    PowerShareKind.powerbank => 'Duży powerbank',
    PowerShareKind.headlamp => 'Latarka czołowa',
  };
}

class PowerShareOffer {
  final String id;
  final PowerShareKind kind;
  final String title;
  final String authorName;

  const PowerShareOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory PowerShareOffer.fromJson(Map<String, dynamic> json) {
    return PowerShareOffer(
      id: json['id'] as String? ?? '',
      kind: PowerShareKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PowerShareKind.powerbank,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PowerShareOffer> seeded() => const [
    PowerShareOffer(
      id: 'ps-agr',
      kind: PowerShareKind.generator,
      title:
          'Mogę pożyczyć agregat prądotwórczy / duży powerbank / latarki czołowe dla sąsiadów w potrzebie',
      authorName: 'Arek, klatka II',
    ),
    PowerShareOffer(
      id: 'ps-bank',
      kind: PowerShareKind.powerbank,
      title: 'Powerbank 20000 mAh — po awarii prądu na Olechowie',
      authorName: 'Kasia',
    ),
  ];
}
