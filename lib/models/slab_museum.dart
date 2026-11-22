class SlabMemory {
  final String id;
  final String title;
  final String era;
  final String body;
  final List<String> memories;

  const SlabMemory({
    required this.id,
    required this.title,
    required this.era,
    required this.body,
    this.memories = const [],
  });

  SlabMemory copyWith({List<String>? memories}) {
    return SlabMemory(
      id: id,
      title: title,
      era: era,
      body: body,
      memories: memories ?? this.memories,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'body': body,
    'memories': memories,
  };

  factory SlabMemory.fromJson(Map<String, dynamic> json) {
    return SlabMemory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
      memories:
          (json['memories'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }

  static List<SlabMemory> seeded() => const [
    SlabMemory(
      id: 'sm-wschod',
      title: 'osiedle wschodnie — pierwszy etap',
      era: 'lata 70.',
      body: 'Żurawie, płyty stropowe, pierwsze klatki przy głównej arterii.',
      memories: ['Mieszkałam w baraku budowy — 1976. — Pani Krysia'],
    ),
    SlabMemory(
      id: 'sm-olech',
      title: 'okolica — punktowce',
      era: 'lata 80.',
      body: 'Wysokie bloki i zieleń między klatkami, jeszcze bez galerii.',
      memories: [],
    ),
  ];
}
