enum CooperativeNoticeKind { water, heating, power, general }

extension CooperativeNoticeKindX on CooperativeNoticeKind {
  String get label => switch (this) {
    CooperativeNoticeKind.water => 'Woda',
    CooperativeNoticeKind.heating => 'Ogrzewanie',
    CooperativeNoticeKind.power => 'Prąd',
    CooperativeNoticeKind.general => 'Ogłoszenie zarządu',
  };
}

class CooperativeNotice {
  final String id;
  final String title;
  final String body;
  final CooperativeNoticeKind kind;
  final String area;
  final DateTime startsAt;
  final DateTime? endsAt;

  const CooperativeNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.kind,
    required this.area,
    required this.startsAt,
    this.endsAt,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'kind': kind.name,
    'area': area,
    'startsAt': startsAt.toIso8601String(),
    'endsAt': endsAt?.toIso8601String(),
  };

  factory CooperativeNotice.fromJson(Map<String, dynamic> json) {
    return CooperativeNotice(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      kind: CooperativeNoticeKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CooperativeNoticeKind.general,
      ),
      area: json['area'] as String? ?? 'Okolica',
      startsAt:
          DateTime.tryParse(json['startsAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
      endsAt: DateTime.tryParse(json['endsAt'] as String? ?? ''),
    );
  }

  static List<CooperativeNotice> seeded() => [
    CooperativeNotice(
      id: 'woda-puszkina',
      title: 'Wyłączenie wody – ul. Parkowa',
      body:
          'spółdzielni: przerwa w dostawie zimnej wody przy ul. Parkowa 8–16. '
          'Prace na przyłączu. Prosimy napełnić zapas.',
      kind: CooperativeNoticeKind.water,
      area: 'osiedle wschodnie · ul. Parkowa',
      startsAt: DateTime(2026, 10, 28, 8),
      endsAt: DateTime(2026, 10, 28, 16),
    ),
    CooperativeNotice(
      id: 'co-olechow',
      title: 'Próba szczelności ogrzewania – okolica',
      body:
          'Planowane napełnianie instalacji C.O. w blokach przy Parkowej. '
          'Możliwy szum w pionach.',
      kind: CooperativeNoticeKind.heating,
      area: 'Twoja okolica',
      startsAt: DateTime(2026, 10, 30, 7),
      endsAt: DateTime(2026, 10, 30, 12),
    ),
    CooperativeNotice(
      id: 'zebranie-janow',
      title: 'Zebranie wspólnoty – okolica',
      body:
          'Zarząd zaprasza na zebranie w świetlicy. Porządek: fundusz remontowy '
          'i harmonogram wywozu gabarytów.',
      kind: CooperativeNoticeKind.general,
      area: 'Twoja okolica',
      startsAt: DateTime(2026, 11, 4, 18),
    ),
  ];
}
