class WaterPressureReport {
  final String id;
  final String block;
  final String floor;
  final String note;
  final String authorName;
  final bool notifyCoop;

  const WaterPressureReport({
    required this.id,
    required this.block,
    required this.floor,
    required this.note,
    required this.authorName,
    this.notifyCoop = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'block': block,
    'floor': floor,
    'note': note,
    'authorName': authorName,
    'notifyCoop': notifyCoop,
  };

  factory WaterPressureReport.fromJson(Map<String, dynamic> json) {
    return WaterPressureReport(
      id: json['id'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      notifyCoop: json['notifyCoop'] as bool? ?? true,
    );
  }

  static List<WaterPressureReport> seeded() => const [
    WaterPressureReport(
      id: 'wp-8',
      block: 'Blok 12, osiedle wschodnie',
      floor: '8. piętro',
      note: 'Rano prawie nie ma ciśnienia w pionie ciepłej wody.',
      authorName: 'Pani Ewa',
    ),
    WaterPressureReport(
      id: 'wp-olech',
      block: 'okolica, klatka III',
      floor: '10. piętro',
      note: 'Spadek wieczorem — prośba o zgłoszenie do spółdzielni.',
      authorName: 'Marek',
    ),
  ];
}
