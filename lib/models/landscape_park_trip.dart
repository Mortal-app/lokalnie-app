enum LandscapeParkKind { wzniesienia, spalski }

extension LandscapeParkKindX on LandscapeParkKind {
  String get label => switch (this) {
    LandscapeParkKind.wzniesienia => 'Wzniesienia Łódzkie',
    LandscapeParkKind.spalski => 'Park Krajobrazowy Spalski',
  };
}

class LandscapeParkTrip {
  final String id;
  final LandscapeParkKind kind;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String seats;
  final String authorName;

  const LandscapeParkTrip({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.seats,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'seats': seats,
    'authorName': authorName,
  };

  factory LandscapeParkTrip.fromJson(Map<String, dynamic> json) {
    return LandscapeParkTrip(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == LandscapeParkKind.spalski.name
          ? LandscapeParkKind.spalski
          : LandscapeParkKind.wzniesienia,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<LandscapeParkTrip> seeded() => const [
    LandscapeParkTrip(
      id: 'lp-wzn',
      kind: LandscapeParkKind.wzniesienia,
      title: 'Weekendowy spacer i piknik — otulina Wzniesień',
      whenText: 'Niedziela 9:00',
      meetingPoint: 'Pętla Widzew Wschód',
      seats: '3 miejsca',
      authorName: 'Basia',
    ),
    LandscapeParkTrip(
      id: 'lp-spa',
      kind: LandscapeParkKind.spalski,
      title: 'Wycieczka piesza — Spalski PK',
      whenText: 'Sobota 8:00',
      meetingPoint: 'Olechów, pawilon',
      seats: '2 miejsca',
      authorName: 'Tomek',
    ),
  ];
}
