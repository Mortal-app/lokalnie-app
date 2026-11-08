enum TerraKind { gecko, stickInsect, turtle, substrate, liveFood }

extension TerraKindX on TerraKind {
  String get label => switch (this) {
    TerraKind.gecko => 'Gekon',
    TerraKind.stickInsect => 'Patyczak',
    TerraKind.turtle => 'Żółw',
    TerraKind.substrate => 'Podłoże do terrarium',
    TerraKind.liveFood => 'Żywy pokarm',
  };
}

class TerrariumOffer {
  final String id;
  final TerraKind kind;
  final String title;
  final String authorName;

  const TerrariumOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory TerrariumOffer.fromJson(Map<String, dynamic> json) {
    return TerrariumOffer(
      id: json['id'] as String? ?? '',
      kind: TerraKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => TerraKind.gecko,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Hodowca',
    );
  }

  static List<TerrariumOffer> seeded() => const [
    TerrariumOffer(
      id: 'tp-gek',
      kind: TerraKind.gecko,
      title: 'Gekon lamparci — porada i wymiana kryjówek',
      authorName: 'Piotr',
    ),
    TerrariumOffer(
      id: 'tp-pat',
      kind: TerraKind.stickInsect,
      title: 'Patyczaki i żywy pokarm — nadwyżka liści jeżyn',
      authorName: 'Kasia',
    ),
  ];
}
