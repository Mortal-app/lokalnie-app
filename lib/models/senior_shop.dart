enum SeniorShopKind { need, volunteer }

extension SeniorShopKindX on SeniorShopKind {
  String get label => switch (this) {
    SeniorShopKind.need => 'Potrzebuję zakupów',
    SeniorShopKind.volunteer => 'Przyniosę z klatki',
  };
}

class SeniorShopOffer {
  final String id;
  final SeniorShopKind kind;
  final String title;
  final String whenText;
  final String authorName;

  const SeniorShopOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenText,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenText': whenText,
    'authorName': authorName,
  };

  factory SeniorShopOffer.fromJson(Map<String, dynamic> json) {
    return SeniorShopOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == SeniorShopKind.volunteer.name
          ? SeniorShopKind.volunteer
          : SeniorShopKind.need,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SeniorShopOffer> seeded() => const [
    SeniorShopOffer(
      id: 'ss-wol',
      kind: SeniorShopKind.volunteer,
      title: 'Zrobię ciężkie zakupy ze sklepu — klatka I, po 17:00',
      whenText: 'Pn–pt po pracy',
      authorName: 'Kuba',
    ),
    SeniorShopOffer(
      id: 'ss-need',
      kind: SeniorShopKind.need,
      title: 'Woda i ziemniaki — trudno wnieść na 4. piętro',
      whenText: 'Jutro przedpołudnie',
      authorName: 'Pani Krystyna',
    ),
  ];
}
