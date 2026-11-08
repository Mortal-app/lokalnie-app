enum ElectroKind { vinyl, gig, midi }

extension ElectroKindX on ElectroKind {
  String get label => switch (this) {
    ElectroKind.vinyl => 'Winyl klubowy',
    ElectroKind.gig => 'Impreza niszowa',
    ElectroKind.midi => 'Muzyka MIDI w domu',
  };
}

class ElectroAmbientPost {
  final String id;
  final ElectroKind kind;
  final String title;
  final String body;
  final String authorName;

  const ElectroAmbientPost({
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

  factory ElectroAmbientPost.fromJson(Map<String, dynamic> json) {
    return ElectroAmbientPost(
      id: json['id'] as String? ?? '',
      kind: ElectroKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ElectroKind.vinyl,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<ElectroAmbientPost> seeded() => const [
    ElectroAmbientPost(
      id: 'ea-vin',
      kind: ElectroKind.vinyl,
      title: 'Ambient / techno — wymiana winyli',
      body: 'Klubowa scena, nie rock. Wymienię 12" na ambient.',
      authorName: 'Marek',
    ),
    ElectroAmbientPost(
      id: 'ea-midi',
      kind: ElectroKind.midi,
      title: 'Domowe MIDI — sesja w blokach',
      body: 'Dawno, Ableton lite. Imprezy niszowe w Łodzi — lista w opisie.',
      authorName: 'Kasia',
    ),
  ];
}
