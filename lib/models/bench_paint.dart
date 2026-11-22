class BenchPaintSlot {
  final String id;
  final String place;
  final String whenText;
  final String note;
  final String authorName;

  const BenchPaintSlot({
    required this.id,
    required this.place,
    required this.whenText,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'place': place,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
  };

  factory BenchPaintSlot.fromJson(Map<String, dynamic> json) {
    return BenchPaintSlot(
      id: json['id'] as String? ?? '',
      place: json['place'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<BenchPaintSlot> seeded() => const [
    BenchPaintSlot(
      id: 'bp-law',
      place: 'Skwer przy pętli, osiedle wschodnie',
      whenText: 'Sobota 9:00',
      note: 'Malowanie ławek — farba do drewna, pędzle ze spółdzielni.',
      authorName: 'Kasia',
    ),
    BenchPaintSlot(
      id: 'bp-trz',
      place: 'Altana i trzepak, okolica',
      whenText: 'Niedziela 10:00',
      note: 'Renowacja małej architektury — grunt i emalia.',
      authorName: 'Marek',
    ),
  ];
}
