enum RtvKind { amp, speaker, receiver }

extension RtvKindX on RtvKind {
  String get label => switch (this) {
    RtvKind.amp => 'Wzmacniacz',
    RtvKind.speaker => 'Głośniki',
    RtvKind.receiver => 'Odbiornik RTV',
  };
}

class RtvRepairSession {
  final String id;
  final RtvKind kind;
  final String title;
  final String whenText;
  final String authorName;

  const RtvRepairSession({
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

  factory RtvRepairSession.fromJson(Map<String, dynamic> json) {
    return RtvRepairSession(
      id: json['id'] as String? ?? '',
      kind: RtvKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => RtvKind.amp,
      ),
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Majster',
    );
  }

  static List<RtvRepairSession> seeded() => const [
    RtvRepairSession(
      id: 'rtv-lut',
      kind: RtvKind.amp,
      title: 'Wspólne lutowanie Unitry — warsztat w piwnicy',
      whenText: 'Sobota 15:00',
      authorName: 'Pan Zbyszek',
    ),
    RtvRepairSession(
      id: 'rtv-glos',
      kind: RtvKind.speaker,
      title: 'Wymiana membran w kolumnach Tonsil',
      whenText: 'Niedziela 11:00',
      authorName: 'Arek',
    ),
  ];
}
