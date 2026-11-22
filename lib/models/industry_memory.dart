class IndustryMemory {
  final String id;
  final String title;
  final String era;
  final String body;

  const IndustryMemory({
    required this.id,
    required this.title,
    required this.era,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'body': body,
  };

  factory IndustryMemory.fromJson(Map<String, dynamic> json) {
    return IndustryMemory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<IndustryMemory> seeded() => const [
    IndustryMemory(
      id: 'im-wima',
      title: 'WiMa — lokalna manufaktura',
      era: 'XIX–XX w.',
      body:
          'Zakłady dawały pracę pokoleniom z wschodniej części miasta. Historia tkanin i osiedla przy fabryce.',
    ),
    IndustryMemory(
      id: 'im-stomil',
      title: 'Stomil',
      era: 'PRL — transformacja',
      body:
          'Guma, opony, zmiany po 1989. Wielu mieszkańców okolicy miało tu etat albo rodzinę na zmianie.',
    ),
  ];
}
