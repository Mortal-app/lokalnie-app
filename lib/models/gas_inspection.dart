class GasInspection {
  final String id;
  final String block;
  final String whenText;
  final String kind;
  final String note;
  final String authorName;

  const GasInspection({
    required this.id,
    required this.block,
    required this.whenText,
    required this.kind,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'block': block,
    'whenText': whenText,
    'kind': kind,
    'note': note,
    'authorName': authorName,
  };

  factory GasInspection.fromJson(Map<String, dynamic> json) {
    return GasInspection(
      id: json['id'] as String? ?? '',
      block: json['block'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      kind: json['kind'] as String? ?? 'Gaz',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Administracja',
    );
  }

  static List<GasInspection> seeded() => const [
    GasInspection(
      id: 'gi-gaz',
      block: 'Blok 12, osiedle wschodnie',
      whenText: '12.11.2026, 8:00–14:00',
      kind: 'Kontrola szczelności gazu',
      note: 'Udostępnij kuchnię, kot niech będzie w pokoju.',
      authorName: 'Spółdzielnia',
    ),
    GasInspection(
      id: 'gi-komin',
      block: 'okolica, klatka III',
      whenText: '18.11.2026',
      kind: 'Przegląd kominiarski',
      note: 'Kratki wentylacyjne — nie zasłaniać.',
      authorName: 'Administracja',
    ),
  ];
}
