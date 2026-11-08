enum TutoringAudience { children, youth, adults }

enum TutoringMode { onsite, online }

extension TutoringAudienceX on TutoringAudience {
  String get label => switch (this) {
    TutoringAudience.children => 'Dla dzieci',
    TutoringAudience.youth => 'Dla młodzieży',
    TutoringAudience.adults => 'Dla dorosłych',
  };
}

extension TutoringModeX on TutoringMode {
  String get label => switch (this) {
    TutoringMode.onsite => 'Stacjonarnie na Widzewie',
    TutoringMode.online => 'Online',
  };
}

class TutoringOffer {
  final String id;
  final String title;
  final String subject;
  final TutoringAudience audience;
  final TutoringMode mode;
  final String authorName;
  final String subDistrict;
  final String note;

  const TutoringOffer({
    required this.id,
    required this.title,
    required this.subject,
    required this.audience,
    required this.mode,
    required this.authorName,
    required this.subDistrict,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'audience': audience.name,
    'mode': mode.name,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'note': note,
  };

  factory TutoringOffer.fromJson(Map<String, dynamic> json) {
    return TutoringOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      audience: TutoringAudience.values.firstWhere(
        (item) => item.name == json['audience'],
        orElse: () => TutoringAudience.youth,
      ),
      mode: TutoringMode.values.firstWhere(
        (item) => item.name == json['mode'],
        orElse: () => TutoringMode.onsite,
      ),
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      note: json['note'] as String? ?? '',
    );
  }

  static List<TutoringOffer> seeded() => const [
    TutoringOffer(
      id: 'tutor-math',
      title: 'Korepetycje z matematyki',
      subject: 'Matematyka',
      audience: TutoringAudience.youth,
      mode: TutoringMode.onsite,
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
      note: 'Szkoła podstawowa i liceum, przy kawie.',
    ),
    TutoringOffer(
      id: 'tutor-en',
      title: 'Angielski w zamian za pomoc w domu',
      subject: 'Języki obce',
      audience: TutoringAudience.adults,
      mode: TutoringMode.online,
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
    ),
    TutoringOffer(
      id: 'tutor-guitar',
      title: 'Nauka gry na gitarze',
      subject: 'Gitara',
      audience: TutoringAudience.children,
      mode: TutoringMode.onsite,
      authorName: 'Sąsiad ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
    TutoringOffer(
      id: 'tutor-code',
      title: 'Podstawy programowania',
      subject: 'Programowanie',
      audience: TutoringAudience.youth,
      mode: TutoringMode.online,
      authorName: 'Sąsiad z Janowa',
      subDistrict: 'Janów',
    ),
  ];
}
