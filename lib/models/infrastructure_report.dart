enum InfrastructureKind { waspNest, sidewalkHole, burntLamp, other }

enum InfrastructureStatus { reportedToZditMpk, inProgress, repaired }

extension InfrastructureKindX on InfrastructureKind {
  String get label => switch (this) {
    InfrastructureKind.waspNest => 'Gniazdo os',
    InfrastructureKind.sidewalkHole => 'Dziura w chodniku',
    InfrastructureKind.burntLamp => 'Spalona latarnia',
    InfrastructureKind.other => 'Inna usterka',
  };
}

extension InfrastructureStatusX on InfrastructureStatus {
  String get label => switch (this) {
    InfrastructureStatus.reportedToZditMpk => 'Zgłoszone do ZDiT / MPK',
    InfrastructureStatus.inProgress => 'W realizacji',
    InfrastructureStatus.repaired => 'Naprawione',
  };
}

class InfrastructureReport {
  final String id;
  final String title;
  final String description;
  final InfrastructureKind kind;
  final InfrastructureStatus status;
  final String place;
  final String subDistrict;
  final double latitude;
  final double longitude;
  final String authorName;

  const InfrastructureReport({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.place,
    required this.subDistrict,
    required this.latitude,
    required this.longitude,
    required this.authorName,
    this.status = InfrastructureStatus.reportedToZditMpk,
  });

  InfrastructureReport copyWith({InfrastructureStatus? status}) {
    return InfrastructureReport(
      id: id,
      title: title,
      description: description,
      kind: kind,
      place: place,
      subDistrict: subDistrict,
      latitude: latitude,
      longitude: longitude,
      authorName: authorName,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'status': status.name,
    'place': place,
    'subDistrict': subDistrict,
    'latitude': latitude,
    'longitude': longitude,
    'authorName': authorName,
  };

  factory InfrastructureReport.fromJson(Map<String, dynamic> json) {
    return InfrastructureReport(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: InfrastructureKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => InfrastructureKind.other,
      ),
      status: InfrastructureStatus.values.firstWhere(
        (item) => item.name == json['status'],
        orElse: () => InfrastructureStatus.reportedToZditMpk,
      ),
      place: json['place'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 51.7478,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 19.5405,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<InfrastructureReport> seeded() => const [
    InfrastructureReport(
      id: 'infra-wasp',
      title: 'Zapomniane gniazdo os przy klatce',
      description: 'Duże gniazdo przy wejściu, utrudnia dojście z wózkiem.',
      kind: InfrastructureKind.waspNest,
      place: 'Olechów, przy śmietniku',
      subDistrict: 'Olechów',
      latitude: 51.7374,
      longitude: 19.5592,
      authorName: 'Sąsiadka z Olechowa',
    ),
    InfrastructureReport(
      id: 'infra-hole',
      title: 'Dziura w chodniku',
      description: 'Głęboka wyrwa przy przejściu, ryzyko potknięcia po zmroku.',
      kind: InfrastructureKind.sidewalkHole,
      place: 'ul. Rokicińska',
      subDistrict: 'Widzew Wschód',
      latitude: 51.7572,
      longitude: 19.5488,
      authorName: 'Sąsiad z Widzewa Wschód',
      status: InfrastructureStatus.inProgress,
    ),
    InfrastructureReport(
      id: 'infra-lamp',
      title: 'Spalona latarnia',
      description: 'Nie świeci od tygodnia, ciemno przy przystanku.',
      kind: InfrastructureKind.burntLamp,
      place: 'ul. Przybyszewskiego',
      subDistrict: 'Stary Widzew',
      latitude: 51.7594,
      longitude: 19.5126,
      authorName: 'Sąsiadka ze Starego Widzewa',
    ),
  ];
}
