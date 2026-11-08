enum FinanceTipKind { budget, energyTariff, rent }

extension FinanceTipKindX on FinanceTipKind {
  String get label => switch (this) {
    FinanceTipKind.budget => 'Budżet domowy',
    FinanceTipKind.energyTariff => 'Taryfa prądu / gazu',
    FinanceTipKind.rent => 'Czynsz',
  };
}

class FinanceTip {
  final String id;
  final FinanceTipKind kind;
  final String title;
  final String body;
  final String authorName;

  const FinanceTip({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory FinanceTip.fromJson(Map<String, dynamic> json) {
    return FinanceTip(
      id: json['id'] as String? ?? '',
      kind: FinanceTipKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FinanceTipKind.budget,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<FinanceTip> seeded() => const [
    FinanceTip(
      id: 'ft-g12',
      kind: FinanceTipKind.energyTariff,
      title: 'Taryfa G12 — pralka po 22:00',
      body:
          'Na Widzewie wielu sąsiadów schodzi na G12: pranie i bojler w tańszej strefie.',
      authorName: 'Basia',
    ),
    FinanceTip(
      id: 'ft-czynsz',
      kind: FinanceTipKind.rent,
      title: 'Rozliczenie wody — odczyt w terminie',
      body:
          'Spóźniony odczyt winduje zaliczki. Kartka na klatce z datą odczytu pomaga.',
      authorName: 'Zarząd klatki',
    ),
  ];
}
