enum MallTarget { tulipan, batory, castorama }

extension MallTargetX on MallTarget {
  String get label => switch (this) {
    MallTarget.tulipan => 'Tulipan',
    MallTarget.batory => 'CH Batory',
    MallTarget.castorama => 'Castorama',
  };
}

class MallCarpoolRide {
  final String id;
  final MallTarget mall;
  final String whenText;
  final String seats;
  final String authorName;

  const MallCarpoolRide({
    required this.id,
    required this.mall,
    required this.whenText,
    required this.seats,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'mall': mall.name,
    'whenText': whenText,
    'seats': seats,
    'authorName': authorName,
  };

  factory MallCarpoolRide.fromJson(Map<String, dynamic> json) {
    return MallCarpoolRide(
      id: json['id'] as String? ?? '',
      mall: MallTarget.values.firstWhere(
        (item) => item.name == json['mall'],
        orElse: () => MallTarget.tulipan,
      ),
      whenText: json['whenText'] as String? ?? '',
      seats: json['seats'] as String? ?? '1 miejsce',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<MallCarpoolRide> seeded() => const [
    MallCarpoolRide(
      id: 'mc-tul',
      mall: MallTarget.tulipan,
      whenText: 'Sobota 10:00, zbiórka przy pętli',
      seats: '2 miejsca — sąsiad bez auta mile widziany',
      authorName: 'Tomek',
    ),
    MallCarpoolRide(
      id: 'mc-cas',
      mall: MallTarget.castorama,
      whenText: 'Niedziela 9:30',
      seats: '1 miejsce + bagażnik na zakupy',
      authorName: 'Kasia',
    ),
  ];
}
