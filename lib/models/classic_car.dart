enum ClassicCarKind { fiat126p, polonez, duzyFiat, mercedes }

extension ClassicCarKindX on ClassicCarKind {
  String get label => switch (this) {
    ClassicCarKind.fiat126p => 'Fiat 126p',
    ClassicCarKind.polonez => 'Polonez',
    ClassicCarKind.duzyFiat => 'Duży Fiat',
    ClassicCarKind.mercedes => 'Klasyczny Mercedes',
  };
}

class ClassicCarMeetup {
  final String id;
  final ClassicCarKind kind;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const ClassicCarMeetup({
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

  factory ClassicCarMeetup.fromJson(Map<String, dynamic> json) {
    return ClassicCarMeetup(
      id: json['id'] as String? ?? '',
      kind: ClassicCarKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ClassicCarKind.fiat126p,
      ),
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? 'Okolica',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<ClassicCarMeetup> seeded() => const [
    ClassicCarMeetup(
      id: 'cc-maluch',
      kind: ClassicCarKind.fiat126p,
      title: 'Spot maluchów na parkingu przy głównej arterii',
      whenText: 'Niedziela 9:00',
      place: 'Okolica',
      authorName: 'Zbyszek',
    ),
    ClassicCarMeetup(
      id: 'cc-polonez',
      kind: ClassicCarKind.polonez,
      title: 'Polonez + Duży Fiat — kawa w okolicy',
      whenText: 'Sobota 16:00',
      place: 'okolica, przy pawilonie',
      authorName: 'Jarek',
    ),
  ];
}
