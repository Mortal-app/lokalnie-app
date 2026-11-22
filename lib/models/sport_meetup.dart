class SportMeetup {
  final String id;
  final String title;
  final String place;
  final String whenLabel;
  final int participantLimit;
  final int joinedCount;
  final bool isJoined;
  final String authorName;
  final String subDistrict;
  final String note;

  const SportMeetup({
    required this.id,
    required this.title,
    required this.place,
    required this.whenLabel,
    required this.participantLimit,
    required this.authorName,
    required this.subDistrict,
    this.joinedCount = 1,
    this.isJoined = false,
    this.note = '',
  });

  bool get isFull => joinedCount >= participantLimit;

  SportMeetup toggleJoin() {
    if (isJoined) {
      return copyWith(
        isJoined: false,
        joinedCount: (joinedCount - 1).clamp(0, participantLimit),
      );
    }
    if (isFull) return this;
    return copyWith(isJoined: true, joinedCount: joinedCount + 1);
  }

  SportMeetup copyWith({int? joinedCount, bool? isJoined}) {
    return SportMeetup(
      id: id,
      title: title,
      place: place,
      whenLabel: whenLabel,
      participantLimit: participantLimit,
      joinedCount: joinedCount ?? this.joinedCount,
      isJoined: isJoined ?? this.isJoined,
      authorName: authorName,
      subDistrict: subDistrict,
      note: note,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'whenLabel': whenLabel,
    'participantLimit': participantLimit,
    'joinedCount': joinedCount,
    'isJoined': isJoined,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'note': note,
  };

  factory SportMeetup.fromJson(Map<String, dynamic> json) {
    return SportMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      participantLimit: json['participantLimit'] as int? ?? 10,
      joinedCount: json['joinedCount'] as int? ?? 1,
      isJoined: json['isJoined'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      note: json['note'] as String? ?? '',
    );
  }

  static List<SportMeetup> seeded() => const [
    SportMeetup(
      id: 'sport-orlik',
      title: 'Szukam chętnych na piłkę nożną we wtorek na Orliku',
      place: 'Orlik okolica',
      whenLabel: 'Wtorek, 18:00',
      participantLimit: 12,
      joinedCount: 7,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
    ),
    SportMeetup(
      id: 'sport-run',
      title: 'Poranne bieganie w Parku Baden-Powella',
      place: 'Park im. Baden-Powella',
      whenLabel: 'Środa, 6:45',
      participantLimit: 8,
      joinedCount: 3,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
    ),
    SportMeetup(
      id: 'sport-bike',
      title: 'Rowerowa masa krytyczna z okolicy',
      place: 'Start: pętla okolica',
      whenLabel: 'Piątek, 17:30',
      participantLimit: 20,
      joinedCount: 11,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
    ),
  ];
}
