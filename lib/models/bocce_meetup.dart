class BocceMeetup {
  final String id;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const BocceMeetup({
    required this.id,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory BocceMeetup.fromJson(Map<String, dynamic> json) {
    return BocceMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<BocceMeetup> seeded() => const [
    BocceMeetup(
      id: 'bc-skw',
      title: 'Pétanque na skwerze — amatorzy',
      whenText: 'Sobota 16:00',
      place: 'Widzew Wschód, skwer przy pętli',
      authorName: 'Bartek',
    ),
    BocceMeetup(
      id: 'bc-traw',
      title: 'Kule / bocce na trawniku osiedlowym',
      whenText: 'Niedziela 11:00',
      place: 'Trawnik przy świetlicy',
      authorName: 'Ola',
    ),
  ];
}
