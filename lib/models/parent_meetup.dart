enum ChildAgeBand { babies, preschool, earlySchool }

enum ParentMeetupKind { playground, swap, schoolPickup }

extension ChildAgeBandX on ChildAgeBand {
  String get label => switch (this) {
    ChildAgeBand.babies => '0–3 lata',
    ChildAgeBand.preschool => '4–7 lat',
    ChildAgeBand.earlySchool => 'Wczesnoszkolne',
  };
}

extension ParentMeetupKindX on ParentMeetupKind {
  String get label => switch (this) {
    ParentMeetupKind.playground => 'Plac zabaw',
    ParentMeetupKind.swap => 'Wymiana zabawek / ubranek',
    ParentMeetupKind.schoolPickup => 'Odbiór ze szkoły / przedszkola',
  };
}

class ParentMeetup {
  final String id;
  final String title;
  final String description;
  final ParentMeetupKind kind;
  final ChildAgeBand ageBand;
  final String place;
  final String authorName;
  final String subDistrict;

  const ParentMeetup({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.ageBand,
    required this.place,
    required this.authorName,
    required this.subDistrict,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'ageBand': ageBand.name,
    'place': place,
    'authorName': authorName,
    'subDistrict': subDistrict,
  };

  factory ParentMeetup.fromJson(Map<String, dynamic> json) {
    return ParentMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: ParentMeetupKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ParentMeetupKind.playground,
      ),
      ageBand: ChildAgeBand.values.firstWhere(
        (item) => item.name == json['ageBand'],
        orElse: () => ChildAgeBand.preschool,
      ),
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
    );
  }

  static List<ParentMeetup> seeded() => const [
    ParentMeetup(
      id: 'parent-puch',
      title: 'Wspólne wyjście na plac zabaw przy Puszkina',
      description: 'Dziś po 16:00, weźcie piaskownice i bidony.',
      kind: ParentMeetupKind.playground,
      ageBand: ChildAgeBand.preschool,
      place: 'Plac zabaw, ul. Puszkina',
      authorName: 'Mama z Widzewa',
      subDistrict: 'Widzew Wschód',
    ),
    ParentMeetup(
      id: 'parent-swap',
      title: 'Wymiana zabawek i ubranek',
      description: 'Rozmiary 74–98, klocki i rowerki biegowe.',
      kind: ParentMeetupKind.swap,
      ageBand: ChildAgeBand.babies,
      place: 'Klatka III, Olechów',
      authorName: 'Tata z Olechowa',
      subDistrict: 'Olechów',
    ),
    ParentMeetup(
      id: 'parent-school',
      title: 'Sąsiedzkie zastępstwo w odebraniu dziecka ze szkoły',
      description: 'Szukam kogoś z trasy przy Przybyszewskiego, wtorek 15:10.',
      kind: ParentMeetupKind.schoolPickup,
      ageBand: ChildAgeBand.earlySchool,
      place: 'SP w rejonie Przybyszewskiego',
      authorName: 'Mama ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
  ];
}
