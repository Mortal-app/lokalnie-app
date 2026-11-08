class ParkPhotoClip {
  final String id;
  final String title;
  final String era;
  final String caption;

  const ParkPhotoClip({
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

  factory ParkPhotoClip.fromJson(Map<String, dynamic> json) {
    return ParkPhotoClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  static List<ParkPhotoClip> seeded() => const [
    ParkPhotoClip(
      id: 'pp-pod',
      title: 'Budowa Parku Podolskiego',
      era: 'lata 70.–80.',
      caption:
          'Aleje, ławki i nasadzenia — opis zdjęcia archiwalnego, bez pliku.',
    ),
    ParkPhotoClip(
      id: 'pp-gor',
      title: 'Górka Widzewska i osiedlowe skwery',
      era: 'lata 90.',
      caption: 'Sanki, trawnik i tablica parku sprzed dekad.',
    ),
  ];
}
