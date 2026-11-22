import 'bike_station.dart';

enum VoltageKind { spike, blackout, phaseDrop }

extension VoltageKindX on VoltageKind {
  String get label => switch (this) {
    VoltageKind.spike => 'Skok napięcia',
    VoltageKind.blackout => 'Całkowity zanik prądu',
    VoltageKind.phaseDrop => 'Zanik fazy',
  };
}

class VoltageOutageReport {
  final String id;
  final VoltageKind kind;
  final String street;
  final String district;
  final String note;
  final String authorName;
  final StationAlign pos;

  const VoltageOutageReport({
    required this.id,
    required this.kind,
    required this.street,
    required this.district,
    required this.note,
    required this.authorName,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'street': street,
    'district': district,
    'note': note,
    'authorName': authorName,
    'pos': pos.name,
  };

  factory VoltageOutageReport.fromJson(Map<String, dynamic> json) {
    return VoltageOutageReport(
      id: json['id'] as String? ?? '',
      kind: VoltageKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => VoltageKind.blackout,
      ),
      street: json['street'] as String? ?? '',
      district: json['district'] as String? ?? 'Twoja okolica',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<VoltageOutageReport> seeded() => const [
    VoltageOutageReport(
      id: 'vo-wschod',
      kind: VoltageKind.spike,
      street: 'ul. Parkowa',
      district: 'Twoja okolica',
      note: 'Migające światła w klatce III, ok. 21:10.',
      authorName: 'Marek',
      pos: StationAlign.topLeft,
    ),
    VoltageOutageReport(
      id: 'vo-olech',
      kind: VoltageKind.blackout,
      street: 'ul. Zakładowa',
      district: 'Twoja okolica',
      note: 'Cały odcinek bez prądu od 18:40.',
      authorName: 'Ola',
      pos: StationAlign.bottomRight,
    ),
  ];
}
