enum EcoReportKind { dump, overflowingBin, damagedTree }

enum EcoInterventionStatus { submitted, acceptedByOffice }

extension EcoReportKindX on EcoReportKind {
  String get label => switch (this) {
    EcoReportKind.dump => 'Dzikie wysypisko',
    EcoReportKind.overflowingBin => 'Przepełniony kosz',
    EcoReportKind.damagedTree => 'Uszkodzone drzewo',
  };
}

extension EcoInterventionStatusX on EcoInterventionStatus {
  String get label => switch (this) {
    EcoInterventionStatus.submitted => 'Zgłoszono',
    EcoInterventionStatus.acceptedByOffice =>
      'Zgłoszenie przyjęte przez urząd / SM',
  };
}

class EcoReport {
  final String id;
  final String title;
  final String place;
  final String description;
  final EcoReportKind kind;
  final EcoInterventionStatus status;
  final DateTime createdAt;

  const EcoReport({
    required this.id,
    required this.title,
    required this.place,
    required this.description,
    required this.kind,
    required this.createdAt,
    this.status = EcoInterventionStatus.submitted,
  });

  EcoReport copyWith({EcoInterventionStatus? status}) {
    return EcoReport(
      id: id,
      title: title,
      place: place,
      description: description,
      kind: kind,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'description': description,
    'kind': kind.name,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory EcoReport.fromJson(Map<String, dynamic> json) {
    return EcoReport(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: EcoReportKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EcoReportKind.dump,
      ),
      status: json['status'] == EcoInterventionStatus.acceptedByOffice.name
          ? EcoInterventionStatus.acceptedByOffice
          : EcoInterventionStatus.submitted,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
    );
  }

  static List<EcoReport> seeded() => [
    EcoReport(
      id: 'eco-jasien',
      title: 'Gałąź nad ścieżką – park nad Jasieniem',
      place: 'Park nad Jasieniem',
      description:
          'Uszkodzone drzewo nachyla się nad alejka. Ryzyko dla rowerzystów.',
      kind: EcoReportKind.damagedTree,
      createdAt: DateTime(2026, 10, 20, 9, 30),
      status: EcoInterventionStatus.acceptedByOffice,
    ),
    EcoReport(
      id: 'eco-kosz-olechow',
      title: 'Przepełnione kosze przy placu zabaw',
      place: 'Olechów · Malownicza',
      description: 'Kosze pełne od weekendu, worki leżą obok.',
      kind: EcoReportKind.overflowingBin,
      createdAt: DateTime(2026, 10, 22, 17),
    ),
  ];
}
