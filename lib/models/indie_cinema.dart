enum IndieCinemaKind { niche, camerimage, documentary, homeScreening }

extension IndieCinemaKindX on IndieCinemaKind {
  String get label => switch (this) {
    IndieCinemaKind.niche => 'Film niszowy',
    IndieCinemaKind.camerimage => 'Camerimage',
    IndieCinemaKind.documentary => 'Festiwal Form Dokumentalnych',
    IndieCinemaKind.homeScreening => 'Seans domowy',
  };
}

class IndieCinemaPost {
  final String id;
  final IndieCinemaKind kind;
  final String title;
  final String body;
  final String authorName;

  const IndieCinemaPost({
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

  factory IndieCinemaPost.fromJson(Map<String, dynamic> json) {
    return IndieCinemaPost(
      id: json['id'] as String? ?? '',
      kind: IndieCinemaKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => IndieCinemaKind.niche,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Widz',
    );
  }

  static List<IndieCinemaPost> seeded() => const [
    IndieCinemaPost(
      id: 'ic-cam',
      kind: IndieCinemaKind.camerimage,
      title: 'Camerimage — wspólny wyjazd na seans operatorski',
      body: 'Zbiórka przy pętli, bilety grupowe. Opinie po filmie na klatce.',
      authorName: 'Marta',
    ),
    IndieCinemaPost(
      id: 'ic-dom',
      kind: IndieCinemaKind.homeScreening,
      title: 'Seans amatorski w świetlicy — krótkie metraże łódzkie',
      body: 'Projektor z klatki, herbata. Sobota 19:00.',
      authorName: 'Piotr',
    ),
  ];
}
