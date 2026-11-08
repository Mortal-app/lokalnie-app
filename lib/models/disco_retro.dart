enum DiscoKind { vhs, cd, houseParty }

extension DiscoKindX on DiscoKind {
  String get label => switch (this) {
    DiscoKind.vhs => 'Kaseta VHS',
    DiscoKind.cd => 'Płyta CD',
    DiscoKind.houseParty => 'Domówka retro',
  };
}

class DiscoRetroPost {
  final String id;
  final DiscoKind kind;
  final String title;
  final String body;
  final String authorName;

  const DiscoRetroPost({
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

  factory DiscoRetroPost.fromJson(Map<String, dynamic> json) {
    return DiscoRetroPost(
      id: json['id'] as String? ?? '',
      kind: DiscoKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => DiscoKind.cd,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<DiscoRetroPost> seeded() => const [
    DiscoRetroPost(
      id: 'dr-vhs',
      kind: DiscoKind.vhs,
      title: 'VHS z festiwalu — pop i disco lat 80.',
      body: 'Nagrania telewizyjne, wymienię na CD z lat 90.',
      authorName: 'Marek',
    ),
    DiscoRetroPost(
      id: 'dr-dom',
      kind: DiscoKind.houseParty,
      title: 'Domówka w klimacie disco 90',
      body: 'Olechów, blok, cisza po 22. Przynieś playlistę na pendrive.',
      authorName: 'Piotr',
    ),
  ];
}
