enum HeatAlertKind { coldRadiator, veoliaWork }

extension HeatAlertKindX on HeatAlertKind {
  String get label => switch (this) {
    HeatAlertKind.coldRadiator => 'Wychłodzony kaloryfer',
    HeatAlertKind.veoliaWork => 'Prace Veolii',
  };
}

class HeatAlert {
  final String id;
  final HeatAlertKind kind;
  final String place;
  final String whenText;
  final String note;
  final String authorName;

  const HeatAlert({
    required this.id,
    required this.kind,
    required this.place,
    required this.whenText,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
  };

  factory HeatAlert.fromJson(Map<String, dynamic> json) {
    return HeatAlert(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == HeatAlertKind.veoliaWork.name
          ? HeatAlertKind.veoliaWork
          : HeatAlertKind.coldRadiator,
      place: json['place'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<HeatAlert> seeded() => const [
    HeatAlert(
      id: 'ha-kal',
      kind: HeatAlertKind.coldRadiator,
      place: 'Klatka II, Widzew Wschód',
      whenText: 'Od rana',
      note: 'Kaloryfery ledwo ciepłe, woda użytkowa też chłodniejsza.',
      authorName: 'Pani Ewa',
    ),
    HeatAlert(
      id: 'ha-veo',
      kind: HeatAlertKind.veoliaWork,
      place: 'Olechów — odcinek Rokicińska',
      whenText: 'Środa 8:00–16:00',
      note: 'Planowane prace Veolii: wyłączenie C.O. i ciepłej wody.',
      authorName: 'Zarząd',
    ),
  ];
}
