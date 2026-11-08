class SchoolPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const SchoolPhotoClip({
    required this.id,
    required this.title,
    required this.era,
    required this.caption,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'caption': caption,
  };

  factory SchoolPhotoClip.fromJson(Map<String, dynamic> json) {
    return SchoolPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<SchoolPhotoClip> seeded() => const [
    SchoolPhotoClip(
      id: 'sp-pod',
      title: 'Szkoła podstawowa na Widzewie Wschodzie',
      era: 'lata 70.–80.',
      caption:
          'Budynek, boisko i szatnia — opis zdjęcia archiwalnego, bez pliku.',
    ),
    SchoolPhotoClip(
      id: 'sp-lic',
      title: 'Liceum we wschodniej Łodzi',
      era: 'lata 90.',
      caption: 'Wejście, tablica i rowerzysty pod szkołą.',
    ),
  ];
}
