enum SafeKind { wall, floor }

extension SafeKindX on SafeKind {
  String get label => switch (this) {
    SafeKind.wall => 'Sejf ścienny',
    SafeKind.floor => 'Sejf podłogowy',
  };
}

class HomeSafeTip {
  final String id;
  final SafeKind kind;
  final String title;
  final String body;
  final String authorName;

  const HomeSafeTip({
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

  factory HomeSafeTip.fromJson(Map<String, dynamic> json) {
    return HomeSafeTip(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == SafeKind.floor.name
          ? SafeKind.floor
          : SafeKind.wall,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<HomeSafeTip> seeded() => const [
    HomeSafeTip(
      id: 'hs-sci',
      kind: SafeKind.wall,
      title: 'Mały sejf w wielkiej płycie — nie wierć w pionie',
      body: 'Kotwy chemiczne, omijaj pustaki i rury. Pomogę namierzyć zbrojenie.',
      authorName: 'Pan Marek',
    ),
    HomeSafeTip(
      id: 'hs-pod',
      kind: SafeKind.floor,
      title: 'Skrytka podłogowa pod panelami',
      body: 'Nie tnij jastrychu na ślepo. Rama i pokrywa zamykana na klucz.',
      authorName: 'Arek',
    ),
  ];
}
