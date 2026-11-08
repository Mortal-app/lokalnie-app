enum DiySkill { soldering, sewing, programming, cooking }

extension DiySkillX on DiySkill {
  String get label => switch (this) {
    DiySkill.soldering => 'Lutowanie',
    DiySkill.sewing => 'Szycie',
    DiySkill.programming => 'Podstawy programowania',
    DiySkill.cooking => 'Gotowanie',
  };
}

class DiyWorkshop {
  final String id;
  final DiySkill skill;
  final String title;
  final String whenLabel;
  final String place;
  final String teacher;

  const DiyWorkshop({
    required this.id,
    required this.skill,
    required this.title,
    required this.whenLabel,
    required this.place,
    required this.teacher,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'skill': skill.name,
    'title': title,
    'whenLabel': whenLabel,
    'place': place,
    'teacher': teacher,
  };

  factory DiyWorkshop.fromJson(Map<String, dynamic> json) {
    return DiyWorkshop(
      id: json['id'] as String? ?? '',
      skill: DiySkill.values.firstWhere(
        (item) => item.name == json['skill'],
        orElse: () => DiySkill.cooking,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      place: json['place'] as String? ?? 'Klub osiedlowy',
      teacher: json['teacher'] as String? ?? 'Sąsiad',
    );
  }

  static List<DiyWorkshop> seeded() => const [
    DiyWorkshop(
      id: 'diy-lut',
      skill: DiySkill.soldering,
      title: 'Chętnie nauczę lutowania — pierwsze złącza',
      whenLabel: 'Sobota 11:00',
      place: 'Klub osiedlowy, Widzew Wschód',
      teacher: 'Pan Jacek',
    ),
    DiyWorkshop(
      id: 'diy-sew',
      skill: DiySkill.sewing,
      title: 'Chętnie nauczę szycia — łatanie i suwak',
      whenLabel: 'Wtorek 18:00',
      place: 'Klub osiedlowy, Stary Widzew',
      teacher: 'Pani Zosia',
    ),
    DiyWorkshop(
      id: 'diy-code',
      skill: DiySkill.programming,
      title: 'Chętnie nauczę podstaw programowania (Python)',
      whenLabel: 'Czwartek 17:30',
      place: 'Klub osiedlowy, Olechów',
      teacher: 'Ania',
    ),
    DiyWorkshop(
      id: 'diy-cook',
      skill: DiySkill.cooking,
      title: 'Chętnie nauczę gotowania — obiad z jednej patelni',
      whenLabel: 'Niedziela 12:00',
      place: 'Klub osiedlowy, Janów',
      teacher: 'Kucharz z klatki',
    ),
  ];
}
