enum OddJobKind { lawn, moving, dogWalk, other }

enum OddJobBudget { upTo50, from50To100, over100 }

extension OddJobKindX on OddJobKind {
  String get label => switch (this) {
    OddJobKind.lawn => 'Trawnik / ROD',
    OddJobKind.moving => 'Przeprowadzka',
    OddJobKind.dogWalk => 'Wyprowadzenie psa',
    OddJobKind.other => 'Inne zlecenie',
  };
}

extension OddJobBudgetX on OddJobBudget {
  String get label => switch (this) {
    OddJobBudget.upTo50 => 'Do 50 zł',
    OddJobBudget.from50To100 => '50–100 zł',
    OddJobBudget.over100 => 'Powyżej 100 zł',
  };

  static OddJobBudget fromAmount(int amount) {
    if (amount <= 50) return OddJobBudget.upTo50;
    if (amount <= 100) return OddJobBudget.from50To100;
    return OddJobBudget.over100;
  }
}

class OddJob {
  final String id;
  final String title;
  final String description;
  final OddJobKind kind;
  final int budget;
  final bool offering;
  final String authorName;
  final String subDistrict;
  final String place;

  const OddJob({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.budget,
    required this.authorName,
    required this.subDistrict,
    required this.place,
    this.offering = false,
  });

  OddJobBudget get budgetBand => OddJobBudgetX.fromAmount(budget);

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'budget': budget,
    'offering': offering,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'place': place,
  };

  factory OddJob.fromJson(Map<String, dynamic> json) {
    return OddJob(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: OddJobKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => OddJobKind.other,
      ),
      budget: json['budget'] as int? ?? 0,
      offering: json['offering'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      place: json['place'] as String? ?? '',
    );
  }

  static List<OddJob> seeded() => const [
    OddJob(
      id: 'job-lawn',
      title: 'Szukam: skoszenie trawnika na działce ROD',
      description: 'Działka w okolicy, kosiarka na miejscu.',
      kind: OddJobKind.lawn,
      budget: 80,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
      place: 'ROD',
    ),
    OddJob(
      id: 'job-move',
      title: 'Pomoc przy przeprowadzce na ul. Tatrzańskiej',
      description: '3 piętro, kanapa i kartony, 2–3 godziny.',
      kind: OddJobKind.moving,
      budget: 150,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      place: 'ul. Tatrzańska',
    ),
    OddJob(
      id: 'job-dog',
      title: 'Oferuję: wyprowadzenie psa w okolicy',
      description: 'Mogę wziąć spacer 30 min po południu.',
      kind: OddJobKind.dogWalk,
      budget: 40,
      offering: true,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      place: 'Okolica',
    ),
  ];
}
