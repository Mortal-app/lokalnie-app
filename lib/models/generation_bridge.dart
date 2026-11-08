enum BridgeKind { youthHelp, seniorShare }

extension BridgeKindX on BridgeKind {
  String get label => switch (this) {
    BridgeKind.youthHelp => 'Młodzież pomaga (smartfon / PC)',
    BridgeKind.seniorShare => 'Senior dzieli się (historia, kuchnia, szydełko)',
  };
}

class GenerationBridgeOffer {
  final String id;
  final BridgeKind kind;
  final String title;
  final String authorName;

  const GenerationBridgeOffer({
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

  factory GenerationBridgeOffer.fromJson(Map<String, dynamic> json) {
    return GenerationBridgeOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == BridgeKind.seniorShare.name
          ? BridgeKind.seniorShare
          : BridgeKind.youthHelp,
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<GenerationBridgeOffer> seeded() => const [
    GenerationBridgeOffer(
      id: 'gb-smart',
      kind: BridgeKind.youthHelp,
      title: 'Pomogę ustawić e-mail i profil zaufany na telefonie',
      authorName: 'Ola, liceum',
    ),
    GenerationBridgeOffer(
      id: 'gb-szyd',
      kind: BridgeKind.seniorShare,
      title: 'Szydełkowanie i opowieści o starym Widzewie — czwartek',
      authorName: 'Pani Krysia',
    ),
  ];
}
