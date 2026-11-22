class OpenAirShow {
  final String id;
  final String title;
  final String place;
  final String whenLabel;
  final int votes;
  final bool iVoted;
  final String authorName;

  const OpenAirShow({
    required this.id,
    required this.title,
    required this.place,
    required this.whenLabel,
    required this.authorName,
    this.votes = 0,
    this.iVoted = false,
  });

  OpenAirShow vote() {
    if (iVoted) return this;
    return OpenAirShow(
      id: id,
      title: title,
      place: place,
      whenLabel: whenLabel,
      authorName: authorName,
      votes: votes + 1,
      iVoted: true,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'whenLabel': whenLabel,
    'votes': votes,
    'iVoted': iVoted,
    'authorName': authorName,
  };

  factory OpenAirShow.fromJson(Map<String, dynamic> json) {
    return OpenAirShow(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Dziedziniec',
      whenLabel: json['whenLabel'] as String? ?? '',
      votes: json['votes'] as int? ?? 0,
      iVoted: json['iVoted'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<OpenAirShow> seeded() => const [
    OpenAirShow(
      id: 'oa-kino',
      title: 'Repertuar: „Miś” — kino pod chmurką',
      place: 'Dziedziniec, Główna',
      whenLabel: 'Piątek 21:00',
      votes: 18,
      authorName: 'Klub osiedlowy',
    ),
    OpenAirShow(
      id: 'oa-teatr',
      title: 'Teatrzyk: bajka dla dzieci',
      place: 'Świetlica osiedlowa, okolica',
      whenLabel: 'Sobota 17:00',
      votes: 11,
      authorName: 'Rada rodziców',
    ),
  ];
}
