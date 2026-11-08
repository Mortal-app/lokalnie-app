enum CampusDest { politechnika, uniwersytet }

extension CampusDestX on CampusDest {
  String get label => switch (this) {
    CampusDest.politechnika => 'Politechnika Łódzka',
    CampusDest.uniwersytet => 'Uniwersytet Łódzki',
  };
}

class StudentRide {
  final String id;
  final CampusDest campus;
  final String fromDistrict;
  final String time;
  final int seats;
  final String authorName;
  final String note;

  const StudentRide({
    required this.id,
    required this.campus,
    required this.fromDistrict,
    required this.time,
    required this.seats,
    required this.authorName,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'campus': campus.name,
    'fromDistrict': fromDistrict,
    'time': time,
    'seats': seats,
    'authorName': authorName,
    'note': note,
  };

  factory StudentRide.fromJson(Map<String, dynamic> json) {
    return StudentRide(
      id: json['id'] as String? ?? '',
      campus: json['campus'] == CampusDest.uniwersytet.name
          ? CampusDest.uniwersytet
          : CampusDest.politechnika,
      fromDistrict: json['fromDistrict'] as String? ?? 'Olechów',
      time: json['time'] as String? ?? '7:40',
      seats: json['seats'] as int? ?? 1,
      authorName: json['authorName'] as String? ?? 'Student',
      note: json['note'] as String? ?? '',
    );
  }

  static List<StudentRide> seeded() => const [
    StudentRide(
      id: 'st-pl',
      campus: CampusDest.politechnika,
      fromDistrict: 'Olechów',
      time: '7:35',
      seats: 2,
      authorName: 'Kasia, sem. 4',
      note: 'Pon–pt, parking przy W-10.',
    ),
    StudentRide(
      id: 'st-ul',
      campus: CampusDest.uniwersytet,
      fromDistrict: 'Widzew Wschód',
      time: '8:00',
      seats: 1,
      authorName: 'Bartek',
      note: 'Wydział Filozoficzno-Historyczny.',
    ),
  ];
}
