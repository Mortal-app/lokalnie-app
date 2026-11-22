class PavilionPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const PavilionPhotoClip({
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

  factory PavilionPhotoClip.fromJson(Map<String, dynamic> json) {
    return PavilionPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<PavilionPhotoClip> seeded() => const [
    PavilionPhotoClip(
      id: 'pp-80',
      title: 'Pawilon handlowy w okolicy',
      era: 'lata 80.',
      caption:
          'Szyldy, kolejka po mięso i blaszany dach — opis zdjęcia, bez pliku.',
    ),
    PavilionPhotoClip(
      id: 'pp-90',
      title: 'Blaszaki i sklepy osiedlowe',
      era: 'lata 90.',
      caption: 'Kontenery handlowe przy pętli, dresy i kasety w witrynie.',
    ),
  ];
}
