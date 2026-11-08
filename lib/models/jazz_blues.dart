enum JazzKind { vinyl, concert, jam }

extension JazzKindX on JazzKind {
  String get label => switch (this) {
    JazzKind.vinyl => 'Płyta jazz / blues',
    JazzKind.concert => 'Koncert w Łodzi',
    JazzKind.jam => 'Spotkanie / jam',
  };
}

class JazzBluesPost {
  final String id;
  final JazzKind kind;
  final String title;
  final String body;
  final String authorName;

  const JazzBluesPost({
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

  factory JazzBluesPost.fromJson(Map<String, dynamic> json) {
    return JazzBluesPost(
      id: json['id'] as String? ?? '',
      kind: JazzKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => JazzKind.vinyl,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Słuchacz',
    );
  }

  static List<JazzBluesPost> seeded() => const [
    JazzBluesPost(
      id: 'jb-klub',
      kind: JazzKind.concert,
      title: 'Klub jazzowy w Łodzi — wspólny wyjazd',
      body: 'Improwizacja, nie rock i nie disco. Spotkanie przy pętli.',
      authorName: 'Piotr',
    ),
    JazzBluesPost(
      id: 'jb-win',
      kind: JazzKind.vinyl,
      title: 'Blues i jazz — wymiana płyt',
      body: 'Winyle i CD, jam w mieszkaniu w niedzielę po 18.',
      authorName: 'Marek',
    ),
  ];
}
