enum HomeDutyKind { waterMeter, gasMeter, powerMeter, gasHeater }

extension HomeDutyKindX on HomeDutyKind {
  String get label => switch (this) {
    HomeDutyKind.waterMeter => 'Spis licznika wody',
    HomeDutyKind.gasMeter => 'Spis licznika gazu',
    HomeDutyKind.powerMeter => 'Spis licznika prądu',
    HomeDutyKind.gasHeater => 'Przegląd piecyka gazowego',
  };
}

class HomeDuty {
  final String id;
  final HomeDutyKind kind;
  final String title;
  final String dueLabel;
  final String note;

  const HomeDuty({
    required this.id,
    required this.kind,
    required this.title,
    required this.dueLabel,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'dueLabel': dueLabel,
    'note': note,
  };

  factory HomeDuty.fromJson(Map<String, dynamic> json) {
    return HomeDuty(
      id: json['id'] as String? ?? '',
      kind: HomeDutyKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => HomeDutyKind.waterMeter,
      ),
      title: json['title'] as String? ?? '',
      dueLabel: json['dueLabel'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  static List<HomeDuty> seeded() => const [
    HomeDuty(
      id: 'duty-water',
      kind: HomeDutyKind.waterMeter,
      title: 'Spis licznika wody',
      dueLabel: 'do 10. dnia miesiąca',
      note: 'Odczyt zimnej i ciepłej wody, kartka na klatce.',
    ),
    HomeDuty(
      id: 'duty-gas',
      kind: HomeDutyKind.gasMeter,
      title: 'Spis licznika gazu',
      dueLabel: 'koniec kwartału',
      note: 'Zdjęcie licznika i wpis w aplikacji gazowni.',
    ),
    HomeDuty(
      id: 'duty-power',
      kind: HomeDutyKind.powerMeter,
      title: 'Spis licznika prądu',
      dueLabel: 'co 2 miesiące',
    ),
    HomeDuty(
      id: 'duty-heater',
      kind: HomeDutyKind.gasHeater,
      title: 'Przegląd piecyków gazowych w bloku',
      dueLabel: 'sezon grzewczy — październik',
      note: 'Serwis spółdzielni, wietrzenie mieszkania.',
    ),
  ];
}
