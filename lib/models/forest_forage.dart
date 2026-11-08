class ForestForageTrip {
  final String id;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String seats;
  final String authorName;

  const ForestForageTrip({
    required this.id,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.seats,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'seats': seats,
    'authorName': authorName,
  };

  factory ForestForageTrip.fromJson(Map<String, dynamic> json) {
    return ForestForageTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<ForestForageTrip> seeded() => const [
    ForestForageTrip(
      id: 'ff-tusz',
      title: 'Grzyby i borówka — lasy w stronę Tuszyna',
      whenText: 'Sobota 5:45',
      meetingPoint: 'Pętla Widzew Wschód',
      seats: '3 wolne miejsca',
      authorName: 'Tomek',
    ),
    ForestForageTrip(
      id: 'ff-stryk',
      title: 'Koluszki / Stryków — runo leśne',
      whenText: 'Niedziela 6:00',
      meetingPoint: 'Olechów, przy pawilonie',
      seats: '2 miejsca, koszyk własny',
      authorName: 'Basia',
    ),
  ];
}
