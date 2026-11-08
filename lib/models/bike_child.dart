enum BikeChildKind { seat, trailer }

extension BikeChildKindX on BikeChildKind {
  String get label => switch (this) {
    BikeChildKind.seat => 'Fotelik rowerowy',
    BikeChildKind.trailer => 'Przyczepka dla dzieci',
  };
}

class BikeChildOffer {
  final String id;
  final BikeChildKind kind;
  final String title;
  final String authorName;

  const BikeChildOffer({
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

  factory BikeChildOffer.fromJson(Map<String, dynamic> json) {
    return BikeChildOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == BikeChildKind.trailer.name
          ? BikeChildKind.trailer
          : BikeChildKind.seat,
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<BikeChildOffer> seeded() => const [
    BikeChildOffer(
      id: 'bc-fot',
      kind: BikeChildKind.seat,
      title: 'Fotelik na bagażnik 9–22 kg — dziecko wyrosło',
      authorName: 'Hania',
    ),
    BikeChildOffer(
      id: 'bc-prz',
      kind: BikeChildKind.trailer,
      title: 'Przyczepka dwuosobowa — hamulec i pasy OK',
      authorName: 'Kasia',
    ),
  ];
}
