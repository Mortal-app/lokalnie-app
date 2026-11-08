class CinemaPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const CinemaPhotoClip({
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

  factory CinemaPhotoClip.fromJson(Map<String, dynamic> json) {
    return CinemaPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<CinemaPhotoClip> seeded() => const [
    CinemaPhotoClip(
      id: 'cp-widz',
      title: 'Dawne kino osiedlowe na Widzewie',
      era: 'lata 70.–80.',
      caption:
          'Sala, afisze i kolejka przed kasą — opis zdjęcia archiwalnego, bez pliku.',
    ),
    CinemaPhotoClip(
      id: 'cp-dk',
      title: 'Dom kultury i seanse na wschodzie Łodzi',
      era: 'lata 90.',
      caption: 'Miejsce spotkań kulturalnych przy pętli — foyer i neon.',
    ),
  ];
}
