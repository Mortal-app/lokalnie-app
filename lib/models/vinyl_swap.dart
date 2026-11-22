enum VinylMediaKind { vinyl, cd, cassette }

extension VinylMediaKindX on VinylMediaKind {
  String get label => switch (this) {
    VinylMediaKind.vinyl => 'Winyl',
    VinylMediaKind.cd => 'CD',
    VinylMediaKind.cassette => 'Kaseta magnetofonowa',
  };
}

class VinylSwapItem {
  final String id;
  final VinylMediaKind kind;
  final String title;
  final String artist;
  final String authorName;
  final bool forSale;

  const VinylSwapItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.artist,
    required this.authorName,
    this.forSale = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'artist': artist,
    'authorName': authorName,
    'forSale': forSale,
  };

  factory VinylSwapItem.fromJson(Map<String, dynamic> json) {
    return VinylSwapItem(
      id: json['id'] as String? ?? '',
      kind: VinylMediaKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => VinylMediaKind.vinyl,
      ),
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kolekcjoner',
      forSale: json['forSale'] as bool? ?? false,
    );
  }

  static List<VinylSwapItem> seeded() => const [
    VinylSwapItem(
      id: 'vs-winyl',
      kind: VinylMediaKind.vinyl,
      title: 'The Dark Side of the Moon',
      artist: 'Pink Floyd',
      authorName: 'Marek z Wschodu',
      forSale: true,
    ),
    VinylSwapItem(
      id: 'vs-kaseta',
      kind: VinylMediaKind.cassette,
      title: 'Kult — Kaseta demo, wymiana',
      artist: 'Kult',
      authorName: 'Ola, okolica',
    ),
  ];
}
