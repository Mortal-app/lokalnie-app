enum ArtKind { paint, graphic, photo }

extension ArtKindX on ArtKind {
  String get label => switch (this) {
    ArtKind.paint => 'Malarstwo',
    ArtKind.graphic => 'Grafika',
    ArtKind.photo => 'Fotografia',
  };
}

class LocalArtWork {
  final String id;
  final ArtKind kind;
  final String title;
  final String contact;
  final String authorName;

  const LocalArtWork({
    required this.id,
    required this.kind,
    required this.title,
    required this.contact,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'contact': contact,
    'authorName': authorName,
  };

  factory LocalArtWork.fromJson(Map<String, dynamic> json) {
    return LocalArtWork(
      id: json['id'] as String? ?? '',
      kind: ArtKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ArtKind.paint,
      ),
      title: json['title'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Twórca',
    );
  }

  static List<LocalArtWork> seeded() => const [
    LocalArtWork(
      id: 'la-plyta',
      kind: ArtKind.paint,
      title: 'Wielka płyta o zmierzchu — olej',
      contact: 'Wiadomość w aplikacji',
      authorName: 'Ania, Widzew Wschód',
    ),
    LocalArtWork(
      id: 'la-foto',
      kind: ArtKind.photo,
      title: 'Klatki Olechowa — cykl analog',
      contact: 'Spotkanie w DH Widzew',
      authorName: 'Jacek',
    ),
  ];
}
