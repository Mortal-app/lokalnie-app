class BalconyWashSlot {
  final String id;
  final String block;
  final String floor;
  final String whenText;
  final String note;
  final String authorName;

  const BalconyWashSlot({
    required this.id,
    required this.block,
    required this.floor,
    required this.whenText,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'block': block,
    'floor': floor,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
  };

  factory BalconyWashSlot.fromJson(Map<String, dynamic> json) {
    return BalconyWashSlot(
      id: json['id'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<BalconyWashSlot> seeded() => const [
    BalconyWashSlot(
      id: 'bw-wsch',
      block: 'Widzew Wschód, klatka II',
      floor: '5–8 piętro',
      whenText: 'Sobota 9:00',
      note: 'Mycie loggii i szyb od zewnątrz — wiadro i teleskop.',
      authorName: 'Kasia',
    ),
    BalconyWashSlot(
      id: 'bw-olech',
      block: 'Olechów, blok przy Zakładowej',
      floor: 'wyższe piętra',
      whenText: 'Niedziela 8:30',
      note: 'Wspólne porządki elewacji loggii, nie wieszamy dywanów.',
      authorName: 'Marek',
    ),
  ];
}
