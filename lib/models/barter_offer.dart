class BarterOffer {
  final String id;
  final String title;
  final String offerItem;
  final String wantItem;
  final String authorName;
  final String subDistrict;
  final String note;

  const BarterOffer({
    required this.id,
    required this.title,
    required this.offerItem,
    required this.wantItem,
    required this.authorName,
    required this.subDistrict,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'offerItem': offerItem,
    'wantItem': wantItem,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'note': note,
  };

  factory BarterOffer.fromJson(Map<String, dynamic> json) {
    return BarterOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      offerItem: json['offerItem'] as String? ?? '',
      wantItem: json['wantItem'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      note: json['note'] as String? ?? '',
    );
  }

  static List<BarterOffer> seeded() => const [
    BarterOffer(
      id: 'barter-jars',
      title: 'Przetwory domowe za sadzonki',
      offerItem: 'Słoiki ogórków i dżemu',
      wantItem: 'Sadzonki ziół / pomidorów',
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
    ),
    BarterOffer(
      id: 'barter-cake',
      title: 'Książka za domowe ciasto',
      offerItem: 'Książka (fantastyka)',
      wantItem: 'Domowe ciasto / drożdżówka',
      authorName: 'Sąsiad z Janowa',
      subDistrict: 'Janów',
    ),
  ];
}
