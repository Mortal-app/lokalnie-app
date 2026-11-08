enum CarrierKind { woven, stretch, buckle }

extension CarrierKindX on CarrierKind {
  String get label => switch (this) {
    CarrierKind.woven => 'Chusta tkana',
    CarrierKind.stretch => 'Chusta elastyczna',
    CarrierKind.buckle => 'Nosidełko troczone',
  };
}

class BabyCarrierOffer {
  final String id;
  final CarrierKind kind;
  final String title;
  final String authorName;

  const BabyCarrierOffer({
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

  factory BabyCarrierOffer.fromJson(Map<String, dynamic> json) {
    return BabyCarrierOffer(
      id: json['id'] as String? ?? '',
      kind: CarrierKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CarrierKind.woven,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<BabyCarrierOffer> seeded() => const [
    BabyCarrierOffer(
      id: 'cr-tk',
      kind: CarrierKind.woven,
      title: 'Chusta tkana 4,6 m — oddam młodym rodzicom',
      authorName: 'Hania',
    ),
    BabyCarrierOffer(
      id: 'cr-nos',
      kind: CarrierKind.buckle,
      title: 'Nosidełko troczone — ergonomia OK',
      authorName: 'Kasia',
    ),
  ];
}
