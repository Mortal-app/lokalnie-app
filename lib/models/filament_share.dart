enum FilamentKind { pla, petg }

extension FilamentKindX on FilamentKind {
  String get label => switch (this) {
    FilamentKind.pla => 'PLA',
    FilamentKind.petg => 'PETG',
  };
}

class FilamentShareOffer {
  final String id;
  final FilamentKind kind;
  final String title;
  final String authorName;

  const FilamentShareOffer({
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

  factory FilamentShareOffer.fromJson(Map<String, dynamic> json) {
    return FilamentShareOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == FilamentKind.petg.name
          ? FilamentKind.petg
          : FilamentKind.pla,
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Drukarz',
    );
  }

  static List<FilamentShareOffer> seeded() => const [
    FilamentShareOffer(
      id: 'fl-pla',
      kind: FilamentKind.pla,
      title: 'Resztka PLA czarny — na awaryjny uchwyt',
      authorName: 'Piotr',
    ),
    FilamentShareOffer(
      id: 'fl-petg',
      kind: FilamentKind.petg,
      title: 'PETG 100 g — uszczelka / część AGD na już',
      authorName: 'Ola',
    ),
  ];
}
