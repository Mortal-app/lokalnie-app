enum RockPostKind { vinyl, concert, festival }

extension RockPostKindX on RockPostKind {
  String get label => switch (this) {
    RockPostKind.vinyl => 'Płyta / winyl',
    RockPostKind.concert => 'Koncert w Łodzi',
    RockPostKind.festival => 'Wyjazd na festiwal',
  };
}

class RockMetalPost {
  final String id;
  final RockPostKind kind;
  final String title;
  final String body;
  final String authorName;

  const RockMetalPost({
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

  factory RockMetalPost.fromJson(Map<String, dynamic> json) {
    return RockMetalPost(
      id: json['id'] as String? ?? '',
      kind: RockPostKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => RockPostKind.vinyl,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<RockMetalPost> seeded() => const [
    RockMetalPost(
      id: 'rm-atlas',
      kind: RockPostKind.concert,
      title: 'Atlas Arena — zapowiedź koncertu',
      body: 'Wspólny dojazd z pętli okolica. Bilety we własnym zakresie.',
      authorName: 'Piotr',
    ),
    RockMetalPost(
      id: 'rm-wyt',
      kind: RockPostKind.vinyl,
      title: 'Klasyka rocka / metal — wymiana płyt',
      body: 'Wytwórnia i półka winylowa — wymienię na polski metal lat 90.',
      authorName: 'Marek',
    ),
  ];
}
