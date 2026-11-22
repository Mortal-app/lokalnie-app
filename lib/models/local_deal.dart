class LocalDeal {
  final String id;
  final String title;
  final String business;
  final String passphrase;
  final String details;
  final String subDistrict;

  const LocalDeal({
    required this.id,
    required this.title,
    required this.business,
    required this.passphrase,
    required this.details,
    required this.subDistrict,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'business': business,
    'passphrase': passphrase,
    'details': details,
    'subDistrict': subDistrict,
  };

  factory LocalDeal.fromJson(Map<String, dynamic> json) {
    return LocalDeal(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      business: json['business'] as String? ?? '',
      passphrase: json['passphrase'] as String? ?? 'Sąsiad',
      details: json['details'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
    );
  }

  static List<LocalDeal> seeded() => [
    LocalDeal(
      id: 'deal-pizza',
      title: '10% na pizzę na wynos',
      business: 'Osiedlowa pizzeria przy Głównej',
      passphrase: 'Sąsiad',
      details: 'Pokaż aplikację albo powiedz hasło przy kasie. Od poniedziałku do czwartku.',
      subDistrict: 'Twoja okolica',
    ),
    LocalDeal(
      id: 'deal-kawa',
      title: 'Druga kawa -50%',
      business: 'Kawiarnia w okolicy',
      passphrase: 'Sąsiad',
      details: 'Dla mieszkańców okolicy, w dni powszednie do 12:00.',
      subDistrict: 'Twoja okolica',
    ),
    LocalDeal(
      id: 'deal-serwis',
      title: 'Rabat na przegląd roweru',
      business: 'Serwis dwóch kółek',
      passphrase: 'Sąsiad',
      details: '15 zł taniej za regulację hamulców po okazaniu hasła.',
      subDistrict: 'Twoja okolica',
    ),
  ];
}
