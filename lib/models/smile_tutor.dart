class SmileTutorOffer {
  final String id;
  final String subject;
  final String level;
  final String whenText;
  final String authorName;

  const SmileTutorOffer({
    required this.id,
    required this.subject,
    required this.level,
    required this.whenText,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'subject': subject,
    'level': level,
    'whenText': whenText,
    'authorName': authorName,
  };

  factory SmileTutorOffer.fromJson(Map<String, dynamic> json) {
    return SmileTutorOffer(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      level: json['level'] as String? ?? 'Szkoła podstawowa',
      whenText: json['whenText'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Uczeń',
    );
  }

  static List<SmileTutorOffer> seeded() => const [
    SmileTutorOffer(
      id: 'st-mat',
      subject: 'Matematyka — klasy 4–6',
      level: 'Szkoła podstawowa',
      whenText: 'Wtorki i czwartki po 16:00, świetlica',
      authorName: 'Ania, liceum III',
    ),
    SmileTutorOffer(
      id: 'st-ang',
      subject: 'Angielski — za uśmiech',
      level: 'Szkoła podstawowa',
      whenText: 'Sobota 11:00, klatka II',
      authorName: 'Kuba, student UŁ',
    ),
  ];
}
