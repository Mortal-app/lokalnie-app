enum LangBookKind { english, german, italian, dictionary }

extension LangBookKindX on LangBookKind {
  String get label => switch (this) {
    LangBookKind.english => 'Angielski',
    LangBookKind.german => 'Niemiecki',
    LangBookKind.italian => 'Włoski',
    LangBookKind.dictionary => 'Słownik',
  };
}

class LangBookOffer {
  final String id;
  final LangBookKind kind;
  final String title;
  final String authorName;

  const LangBookOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory LangBookOffer.fromJson(Map<String, dynamic> json) {
    return LangBookOffer(
      id: json['id'] as String? ?? '',
      kind: LangBookKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => LangBookKind.english,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Uczeń',
    );
  }

  static List<LangBookOffer> seeded() => const [
    LangBookOffer(
      id: 'lb-en',
      kind: LangBookKind.english,
      title: 'Headway Intermediate — oddam za słownik DE',
      authorName: 'Ania',
    ),
    LangBookOffer(
      id: 'lb-it',
      kind: LangBookKind.italian,
      title: 'Nuovo Espresso 2 + słownik kieszonkowy',
      authorName: 'Kuba, student',
    ),
  ];
}
