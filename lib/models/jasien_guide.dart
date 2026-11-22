class JasienSpot {
  final String id;
  final String name;
  final String kind;
  final String hint;
  final AlignmentPos pos;

  const JasienSpot({
    required this.id,
    required this.name,
    required this.kind,
    required this.hint,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'kind': kind,
    'hint': hint,
    'pos': pos.name,
  };

  factory JasienSpot.fromJson(Map<String, dynamic> json) {
    return JasienSpot(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      kind: json['kind'] as String? ?? 'ścieżka',
      hint: json['hint'] as String? ?? '',
      pos: AlignmentPos.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => AlignmentPos.center,
      ),
    );
  }

  static List<JasienSpot> seeded() => const [
    JasienSpot(
      id: 'js-sciezka',
      name: 'Pętla rowerowa nad rzeką',
      kind: 'ścieżka rowerowa',
      hint: 'Asfalt + szuter, ok. 4 km, łagodne wzniesienia.',
      pos: AlignmentPos.center,
    ),
    JasienSpot(
      id: 'js-lawki',
      name: 'Ławki przy stawie',
      kind: 'wypoczynek',
      hint: 'Cień wierzb, dobry na książkę i kanapki.',
      pos: AlignmentPos.bottomRight,
    ),
    JasienSpot(
      id: 'js-plaza',
      name: 'Polana od strony osiedla',
      kind: 'wypoczynek',
      hint: 'Koce, gry plenerowe, zachód słońca.',
      pos: AlignmentPos.topLeft,
    ),
  ];
}

enum AlignmentPos { topLeft, center, bottomRight }
