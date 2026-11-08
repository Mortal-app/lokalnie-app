enum SafetyKitKind { carExtinguisher, homeExtinguisher, firstAid }

extension SafetyKitKindX on SafetyKitKind {
  String get label => switch (this) {
    SafetyKitKind.carExtinguisher => 'Gaśnica samochodowa',
    SafetyKitKind.homeExtinguisher => 'Gaśnica domowa',
    SafetyKitKind.firstAid => 'Apteczka pierwszej pomocy',
  };
}

class SafetyKitLog {
  final String id;
  final SafetyKitKind kind;
  final String title;
  final int daysUntilReview;
  final String note;
  final String authorName;

  const SafetyKitLog({
    required this.id,
    required this.kind,
    required this.title,
    required this.daysUntilReview,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'daysUntilReview': daysUntilReview,
    'note': note,
    'authorName': authorName,
  };

  factory SafetyKitLog.fromJson(Map<String, dynamic> json) {
    return SafetyKitLog(
      id: json['id'] as String? ?? '',
      kind: SafetyKitKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SafetyKitKind.homeExtinguisher,
      ),
      title: json['title'] as String? ?? '',
      daysUntilReview: json['daysUntilReview'] as int? ?? 0,
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SafetyKitLog> seeded() => const [
    SafetyKitLog(
      id: 'sk-gas',
      kind: SafetyKitKind.homeExtinguisher,
      title: 'Gaśnica na klatce — legalizacja',
      daysUntilReview: 42,
      note: 'Przegląd gaśnicy, nie czujnik dymu.',
      authorName: 'Ewa',
    ),
    SafetyKitLog(
      id: 'sk-apt',
      kind: SafetyKitKind.firstAid,
      title: 'Apteczka w aucie i w domu',
      daysUntilReview: 18,
      note: 'Plastry i woda utleniona — data ważności.',
      authorName: 'Marek',
    ),
  ];
}
