class PavementCleanSlot {
  final String id;
  final String block;
  final String whenText;
  final String note;
  final String authorName;

  const PavementCleanSlot({
    required this.id,
    required this.block,
    required this.whenText,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'block': block,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
  };

  factory PavementCleanSlot.fromJson(Map<String, dynamic> json) {
    return PavementCleanSlot(
      id: json['id'] as String? ?? '',
      block: json['block'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PavementCleanSlot> seeded() => const [
    PavementCleanSlot(
      id: 'pv-wsch',
      block: 'Widzew Wschód, klatka I',
      whenText: 'Sobota 9:00',
      note: 'Kostka i podjazd dla wózków przy wejściu — myjka i szczotki.',
      authorName: 'Kasia',
    ),
    PavementCleanSlot(
      id: 'pv-olech',
      block: 'Olechów, wejście B',
      whenText: 'Niedziela 8:30',
      note: 'Chodnik od śmietnika do drzwi — nie zastawiać wózkami.',
      authorName: 'Marek',
    ),
  ];
}
