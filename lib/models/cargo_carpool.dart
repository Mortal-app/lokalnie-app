enum CargoVehicleKind { kombi, van }

extension CargoVehicleKindX on CargoVehicleKind {
  String get label => switch (this) {
    CargoVehicleKind.kombi => 'Kombi',
    CargoVehicleKind.van => 'Dostawcze',
  };
}

class CargoCarpoolOffer {
  final String id;
  final CargoVehicleKind kind;
  final String title;
  final String whenLabel;
  final String authorName;

  const CargoCarpoolOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'authorName': authorName,
  };

  factory CargoCarpoolOffer.fromJson(Map<String, dynamic> json) {
    return CargoCarpoolOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == CargoVehicleKind.van.name
          ? CargoVehicleKind.van
          : CargoVehicleKind.kombi,
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<CargoCarpoolOffer> seeded() => const [
    CargoCarpoolOffer(
      id: 'cg-ikea',
      kind: CargoVehicleKind.kombi,
      title: 'Kombi — pomoc z dużym zakupem meblowym (IKEA / Agata)',
      whenLabel: 'Sobota 9–14',
      authorName: 'Tomek',
    ),
    CargoCarpoolOffer(
      id: 'cg-dost',
      kind: CargoVehicleKind.van,
      title: 'Dostawcze — kanapa ze sklepu na Olechów',
      whenLabel: 'Niedziela rano',
      authorName: 'Arek',
    ),
  ];
}
