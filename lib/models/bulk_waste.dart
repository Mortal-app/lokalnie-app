class BulkWasteReport {
  final String id;
  final String item;
  final String place;
  final String pickupLabel;
  final String authorName;

  const BulkWasteReport({
    required this.id,
    required this.item,
    required this.place,
    required this.pickupLabel,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'item': item,
    'place': place,
    'pickupLabel': pickupLabel,
    'authorName': authorName,
  };

  factory BulkWasteReport.fromJson(Map<String, dynamic> json) {
    return BulkWasteReport(
      id: json['id'] as String? ?? '',
      item: json['item'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      pickupLabel: json['pickupLabel'] as String? ?? 'Harmonogram MPO',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<BulkWasteReport> seeded() => const [
    BulkWasteReport(
      id: 'bw-sofa',
      item: 'Stara sofa przy śmietniku A',
      place: 'Rokicińska 140',
      pickupLabel: 'Odbiór MPO Łódź: wtorek 4.11, od 6:00',
      authorName: 'Sąsiad z Wschodu',
    ),
    BulkWasteReport(
      id: 'bw-szafa',
      item: 'Szafa drewniana — wystawiona przy klatce',
      place: 'Olechów, klatka V',
      pickupLabel: 'Gabaryty: pierwszy wtorek miesiąca',
      authorName: 'Kasia',
    ),
  ];
}
