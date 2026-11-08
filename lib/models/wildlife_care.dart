enum WildlifeCareKind { birdFeed, injured }

extension WildlifeCareKindX on WildlifeCareKind {
  String get label => switch (this) {
    WildlifeCareKind.birdFeed => 'Dokarmianie ptaków',
    WildlifeCareKind.injured => 'Ranne zwierzę',
  };
}

class WildlifeCareReport {
  final String id;
  final WildlifeCareKind kind;
  final String place;
  final String note;
  final String authorName;

  const WildlifeCareReport({
    required this.id,
    required this.kind,
    required this.place,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'note': note,
    'authorName': authorName,
  };

  factory WildlifeCareReport.fromJson(Map<String, dynamic> json) {
    return WildlifeCareReport(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == WildlifeCareKind.injured.name
          ? WildlifeCareKind.injured
          : WildlifeCareKind.birdFeed,
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<WildlifeCareReport> seeded() => const [
    WildlifeCareReport(
      id: 'wc-ptaki',
      kind: WildlifeCareKind.birdFeed,
      place: 'Park Górka Widzewska',
      note: 'Karmnik przy alejce — słonecznik, nie chleb.',
      authorName: 'Pani Krysia',
    ),
    WildlifeCareReport(
      id: 'wc-ranny',
      kind: WildlifeCareKind.injured,
      place: 'Puszkina, przy parkingu',
      note: 'Gołąb z uszkodzonym skrzydłem — proszę o klatkę.',
      authorName: 'Ania',
    ),
  ];
}
