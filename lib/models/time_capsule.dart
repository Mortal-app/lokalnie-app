class TimeCapsuleEntry {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String sealedAt;
  final String opensAt;
  final bool isSharedLetter;

  const TimeCapsuleEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.sealedAt,
    required this.opensAt,
    this.isSharedLetter = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'authorName': authorName,
    'sealedAt': sealedAt,
    'opensAt': opensAt,
    'isSharedLetter': isSharedLetter,
  };

  factory TimeCapsuleEntry.fromJson(Map<String, dynamic> json) {
    return TimeCapsuleEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Mieszkaniec',
      sealedAt: json['sealedAt'] as String? ?? '28.10.2026',
      opensAt: json['opensAt'] as String? ?? '28.10.2036',
      isSharedLetter: json['isSharedLetter'] as bool? ?? false,
    );
  }

  static List<TimeCapsuleEntry> seeded() => const [
    TimeCapsuleEntry(
      id: 'tc-letter',
      title: 'Wspólny list do przyszłych pokoleń',
      body:
          'Drodzy mieszkańcy Widzewa z 2036: zostawiamy wam wspomnienie bloków, Olechowa i sąsiedzkiej tablicy. Otwórzcie ten list za 10 lat.',
      authorName: 'Mieszkańcy Widzewa',
      sealedAt: '28.10.2026',
      opensAt: '28.10.2036',
      isSharedLetter: true,
    ),
    TimeCapsuleEntry(
      id: 'tc-foto',
      title: 'Zdjęcie podwórka przy Puszkinie, jesień 2026',
      body: 'Klomby, ławki i nowa piaskownica — zapisane na pamiątkę.',
      authorName: 'Kasia',
      sealedAt: '13.10.2026',
      opensAt: '13.10.2036',
    ),
  ];
}
