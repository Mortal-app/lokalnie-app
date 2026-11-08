class BazaarPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const BazaarPhotoClip({
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

  factory BazaarPhotoClip.fromJson(Map<String, dynamic> json) {
    return BazaarPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<BazaarPhotoClip> seeded() => const [
    BazaarPhotoClip(
      id: 'bz-90',
      title: 'Ryneczek osiedlowy — lata 90.',
      era: 'lata 90.',
      caption:
          'Stoiska, foliowe torebki i kolejka po warzywa — opis zdjęcia, bez pliku.',
    ),
    BazaarPhotoClip(
      id: 'bz-hand',
      title: 'Handel przy pętli na Widzewie Wschodzie',
      era: 'lata 90.',
      caption: 'Budki, dresy i kasety — targowisko wschodniej Łodzi.',
    ),
  ];
}
