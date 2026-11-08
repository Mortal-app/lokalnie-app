enum OperaKind { recording, spektakl, outing }

extension OperaKindX on OperaKind {
  String get label => switch (this) {
    OperaKind.recording => 'Nagranie / płyta',
    OperaKind.spektakl => 'Spektakl w Teatrze Wielkim',
    OperaKind.outing => 'Wspólne wyjście',
  };
}

class ClassicalOperaPost {
  final String id;
  final OperaKind kind;
  final String title;
  final String body;
  final String authorName;

  const ClassicalOperaPost({
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

  factory ClassicalOperaPost.fromJson(Map<String, dynamic> json) {
    return ClassicalOperaPost(
      id: json['id'] as String? ?? '',
      kind: OperaKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => OperaKind.recording,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Słuchacz',
    );
  }

  static List<ClassicalOperaPost> seeded() => const [
    ClassicalOperaPost(
      id: 'co-tw',
      kind: OperaKind.spektakl,
      title: 'Teatr Wielki w Łodzi — wspólny wyjazd',
      body: 'Spotkanie przy pętli. Bilety we własnym zakresie.',
      authorName: 'Piotr',
    ),
    ClassicalOperaPost(
      id: 'co-plyt',
      kind: OperaKind.recording,
      title: 'Płyty klasyczne i opera — wymiana',
      body: 'CD i winyle, nie jazz i nie rock.',
      authorName: 'Marek',
    ),
  ];
}
