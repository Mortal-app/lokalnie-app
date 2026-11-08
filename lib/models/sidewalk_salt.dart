enum SaltKind { salt, sand, mix }

extension SaltKindX on SaltKind {
  String get label => switch (this) {
    SaltKind.salt => 'Sól',
    SaltKind.sand => 'Piasek',
    SaltKind.mix => 'Sól i piasek',
  };
}

class SidewalkSaltReport {
  final String id;
  final SaltKind kind;
  final String place;
  final String note;
  final String authorName;

  const SidewalkSaltReport({
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

  factory SidewalkSaltReport.fromJson(Map<String, dynamic> json) {
    return SidewalkSaltReport(
      id: json['id'] as String? ?? '',
      kind: SaltKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SaltKind.salt,
      ),
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SidewalkSaltReport> seeded() => const [
    SidewalkSaltReport(
      id: 'ss-klat',
      kind: SaltKind.mix,
      place: 'Chodnik przy klatce I, Widzew Wschód',
      note: 'Ślisko przy schodach — potrzebny piasek i sól.',
      authorName: 'Kasia',
    ),
    SidewalkSaltReport(
      id: 'ss-podj',
      kind: SaltKind.sand,
      place: 'Olechów, podjazd do klatki III',
      note: 'Akcja posypywania w sobotę rano.',
      authorName: 'Marek',
    ),
  ];
}
