enum YardGameKind { caps, rope, hopscotch, bowls }

extension YardGameKindX on YardGameKind {
  String get label => switch (this) {
    YardGameKind.caps => 'Kapsle',
    YardGameKind.rope => 'Guma do skakania',
    YardGameKind.hopscotch => 'Klasy',
    YardGameKind.bowls => 'Bule podwórkowe',
  };
}

class YardGameMeetup {
  final String id;
  final YardGameKind kind;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const YardGameMeetup({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory YardGameMeetup.fromJson(Map<String, dynamic> json) {
    return YardGameMeetup(
      id: json['id'] as String? ?? '',
      kind: YardGameKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => YardGameKind.caps,
      ),
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Organizator',
    );
  }

  static List<YardGameMeetup> seeded() => const [
    YardGameMeetup(
      id: 'yg-kap',
      kind: YardGameKind.caps,
      title: 'Turniej kapśli — dzieci i dorośli',
      whenText: 'Sobota 11:00',
      place: 'Podwórko przy klatce II',
      authorName: 'Kasia',
    ),
    YardGameMeetup(
      id: 'yg-kla',
      kind: YardGameKind.hopscotch,
      title: 'Klasy i guma do skakania',
      whenText: 'Niedziela 16:00',
      place: 'okolica, skwer',
      authorName: 'Hania',
    ),
  ];
}
