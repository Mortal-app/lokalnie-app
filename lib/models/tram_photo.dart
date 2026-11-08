class TramPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const TramPhotoClip({
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

  factory TramPhotoClip.fromJson(Map<String, dynamic> json) {
    return TramPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<TramPhotoClip> seeded() => const [
    TramPhotoClip(
      id: 'tp-petla',
      title: 'Dawna pętla na Widzewie Wschodzie',
      era: 'lata 80.',
      caption:
          'Rozjazdy i wagon 805Na na pętli — opis zdjęcia archiwalnego, bez pliku.',
    ),
    TramPhotoClip(
      id: 'tp-olech',
      title: 'Pętla i tory w stronę Olechowa',
      era: 'lata 90.',
      caption: 'Linia na wschód Łodzi, zajezdnia w tle, commuters przy słupku.',
    ),
  ];
}
