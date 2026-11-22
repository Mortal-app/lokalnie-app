enum CompostKind { bin, worms, bucket }

extension CompostKindX on CompostKind {
  String get label => switch (this) {
    CompostKind.bin => 'Kompostownik',
    CompostKind.worms => 'Dżdżownice kalifornijskie',
    CompostKind.bucket => 'Wiaderko na bio-odpad',
  };
}

class CompostSwap {
  final String id;
  final CompostKind kind;
  final String title;
  final String garden;
  final String authorName;

  const CompostSwap({
    required this.id,
    required this.kind,
    required this.title,
    required this.garden,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'garden': garden,
    'authorName': authorName,
  };

  factory CompostSwap.fromJson(Map<String, dynamic> json) {
    return CompostSwap(
      id: json['id'] as String? ?? '',
      kind: CompostKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CompostKind.bin,
      ),
      title: json['title'] as String? ?? '',
      garden: json['garden'] as String? ?? 'ROD okolica',
      authorName: json['authorName'] as String? ?? 'Działkowiec',
    );
  }

  static List<CompostSwap> seeded() => const [
    CompostSwap(
      id: 'cs-bin',
      kind: CompostKind.bin,
      title: 'Oddam kompostownik 300 l — ROD Reymonta',
      garden: 'ROD im. Władysława Reymonta',
      authorName: 'Pan Józef',
    ),
    CompostSwap(
      id: 'cs-worms',
      kind: CompostKind.worms,
      title: 'Nadwyżka dżdżownic kalifornijskich',
      garden: 'Balkon, okolica',
      authorName: 'Ania',
    ),
  ];
}
