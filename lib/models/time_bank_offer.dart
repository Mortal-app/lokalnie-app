class TimeBankOffer {
  final String id;
  final String title;
  final String offer;
  final String want;
  final int hours;
  final String authorName;
  final String subDistrict;
  final bool isNeed;
  final bool isCompleted;

  const TimeBankOffer({
    required this.id,
    required this.title,
    required this.offer,
    required this.want,
    required this.hours,
    required this.authorName,
    required this.subDistrict,
    this.isNeed = false,
    this.isCompleted = false,
  });

  TimeBankOffer copyWith({bool? isCompleted}) {
    return TimeBankOffer(
      id: id,
      title: title,
      offer: offer,
      want: want,
      hours: hours,
      authorName: authorName,
      subDistrict: subDistrict,
      isNeed: isNeed,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'offer': offer,
    'want': want,
    'hours': hours,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'isNeed': isNeed,
    'isCompleted': isCompleted,
  };

  factory TimeBankOffer.fromJson(Map<String, dynamic> json) {
    return TimeBankOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      offer: json['offer'] as String? ?? '',
      want: json['want'] as String? ?? '',
      hours: json['hours'] as int? ?? 1,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      isNeed: json['isNeed'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  static List<TimeBankOffer> seeded() => [
    TimeBankOffer(
      id: 'tb-angielski',
      title: 'Korepetycje z angielskiego',
      offer: 'Dam 1h korepetycji z angielskiego',
      want: 'w zamian za skoszenie trawnika',
      hours: 1,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
    ),
    TimeBankOffer(
      id: 'tb-pralka',
      title: 'Wniesienie pralki',
      offer: 'Odwdzięczę się kawą i godziną pomocy w domu',
      want: 'Kto pomoże wnieść pralkę na 3 piętro?',
      hours: 1,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      isNeed: true,
    ),
  ];
}
