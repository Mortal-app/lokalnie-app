enum BeachKind { mattress, windbreak, ball, accessory }

extension BeachKindX on BeachKind {
  String get label => switch (this) {
    BeachKind.mattress => 'Materac dmuchany',
    BeachKind.windbreak => 'Parawan',
    BeachKind.ball => 'Piłka',
    BeachKind.accessory => 'Akcesoria plażowe',
  };
}

class BeachGearOffer {
  final String id;
  final BeachKind kind;
  final String title;
  final String authorName;

  const BeachGearOffer({
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

  factory BeachGearOffer.fromJson(Map<String, dynamic> json) {
    return BeachGearOffer(
      id: json['id'] as String? ?? '',
      kind: BeachKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BeachKind.accessory,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<BeachGearOffer> seeded() => const [
    BeachGearOffer(
      id: 'bg-mat',
      kind: BeachKind.mattress,
      title: 'Dmuchany materac — oddam na wyjazd nad wodę',
      authorName: 'Hania',
    ),
    BeachGearOffer(
      id: 'bg-par',
      kind: BeachKind.windbreak,
      title: 'Parawan i piłka — komplet na lato',
      authorName: 'Kasia',
    ),
  ];
}
