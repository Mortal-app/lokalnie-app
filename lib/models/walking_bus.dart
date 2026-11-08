enum WalkingSchool { sp114, sp34, sp141 }

extension WalkingSchoolX on WalkingSchool {
  String get label => switch (this) {
    WalkingSchool.sp114 => 'SP 114',
    WalkingSchool.sp34 => 'SP 34',
    WalkingSchool.sp141 => 'SP 141',
  };
}

class WalkingBusShift {
  final String id;
  final WalkingSchool school;
  final String time;
  final String staircase;
  final String walkerName;
  final String dayLabel;

  const WalkingBusShift({
    required this.id,
    required this.school,
    required this.time,
    required this.staircase,
    required this.walkerName,
    required this.dayLabel,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'school': school.name,
    'time': time,
    'staircase': staircase,
    'walkerName': walkerName,
    'dayLabel': dayLabel,
  };

  factory WalkingBusShift.fromJson(Map<String, dynamic> json) {
    return WalkingBusShift(
      id: json['id'] as String? ?? '',
      school: WalkingSchool.values.firstWhere(
        (item) => item.name == json['school'],
        orElse: () => WalkingSchool.sp114,
      ),
      time: json['time'] as String? ?? '7:30',
      staircase: json['staircase'] as String? ?? 'Klatka I',
      walkerName: json['walkerName'] as String? ?? 'Rodzic',
      dayLabel: json['dayLabel'] as String? ?? 'Dziś',
    );
  }

  static List<WalkingBusShift> seeded() => const [
    WalkingBusShift(
      id: 'wb-114',
      school: WalkingSchool.sp114,
      time: '7:25',
      staircase: 'Klatka II, Olechów',
      walkerName: 'Mama z Olechowa',
      dayLabel: 'Dziś',
    ),
    WalkingBusShift(
      id: 'wb-34',
      school: WalkingSchool.sp34,
      time: '7:40',
      staircase: 'Klatka I, Stary Widzew',
      walkerName: 'Tata ze Starego Widzewa',
      dayLabel: 'Jutro',
    ),
    WalkingBusShift(
      id: 'wb-141',
      school: WalkingSchool.sp141,
      time: '7:35',
      staircase: 'Puszkina 12',
      walkerName: 'Sąsiadka z Widzewa',
      dayLabel: 'Środa',
    ),
  ];
}
