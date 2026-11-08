class SharedTool {
  final String id;
  final String name;
  final String description;
  final List<String> reservedDates;

  const SharedTool({
    required this.id,
    required this.name,
    required this.description,
    this.reservedDates = const [],
  });

  SharedTool copyWith({List<String>? reservedDates}) {
    return SharedTool(
      id: id,
      name: name,
      description: description,
      reservedDates: reservedDates ?? this.reservedDates,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'reservedDates': reservedDates,
  };

  factory SharedTool.fromJson(Map<String, dynamic> json) {
    return SharedTool(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      reservedDates: (json['reservedDates'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }

  static List<SharedTool> seeded() => const [
    SharedTool(
      id: 'tool-ladder',
      name: 'Drabina aluminiowa',
      description: 'Klub mieszkańca, 3 metry.',
      reservedDates: ['2026-10-30'],
    ),
    SharedTool(
      id: 'tool-vac',
      name: 'Odkurzacz piorący',
      description: 'Do dywanów, kaucja nie wymagana.',
    ),
    SharedTool(
      id: 'tool-washer',
      name: 'Myjka ciśnieniowa',
      description: 'Podjazd i rowery, odbiór w klubie.',
      reservedDates: ['2026-11-02'],
    ),
  ];
}
