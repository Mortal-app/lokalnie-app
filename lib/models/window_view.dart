enum WindowViewKind { sunrise, sunset, unique }

extension WindowViewKindX on WindowViewKind {
  String get label => switch (this) {
    WindowViewKind.sunrise => 'Wschód nad blokami',
    WindowViewKind.sunset => 'Zachód nad blokami',
    WindowViewKind.unique => 'Widok z okna',
  };
}

class WindowViewPhoto {
  final String id;
  final WindowViewKind kind;
  final String title;
  final String caption;
  final String authorName;

  const WindowViewPhoto({
    required this.id,
    required this.kind,
    required this.title,
    required this.caption,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'caption': caption,
    'authorName': authorName,
  };

  factory WindowViewPhoto.fromJson(Map<String, dynamic> json) {
    return WindowViewPhoto(
      id: json['id'] as String? ?? '',
      kind: WindowViewKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => WindowViewKind.unique,
      ),
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Mieszkaniec',
    );
  }

  static List<WindowViewPhoto> seeded() => const [
    WindowViewPhoto(
      id: 'wv-wschod',
      kind: WindowViewKind.sunrise,
      title: 'Wschód z 10. piętra, okolica',
      caption: 'Opis zdjęcia: różowe niebo nad wielką płytą, 13.10.2026.',
      authorName: 'Ola',
    ),
    WindowViewPhoto(
      id: 'wv-zachod',
      kind: WindowViewKind.sunset,
      title: 'Zachód z okna na Puszkinie',
      caption: 'Opis zdjęcia: cień komina i złote balkony.',
      authorName: 'Marek',
    ),
  ];
}
