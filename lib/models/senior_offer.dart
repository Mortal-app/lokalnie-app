enum SeniorOfferKind { walk, coffeeChess, officeHelp, volunteer }

extension SeniorOfferKindX on SeniorOfferKind {
  String get label => switch (this) {
    SeniorOfferKind.walk => 'Spacer sąsiedzki',
    SeniorOfferKind.coffeeChess => 'Wspólna kawa / szachy',
    SeniorOfferKind.officeHelp => 'Pomoc urzędowa / cyfrowa',
    SeniorOfferKind.volunteer => 'Chcę pomagać seniorom',
  };
}

class SeniorOffer {
  final String id;
  final String title;
  final String description;
  final SeniorOfferKind kind;
  final String contact;
  final String authorName;
  final String subDistrict;
  final bool wantsHelp;

  const SeniorOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.contact,
    required this.authorName,
    required this.subDistrict,
    this.wantsHelp = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'contact': contact,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'wantsHelp': wantsHelp,
  };

  factory SeniorOffer.fromJson(Map<String, dynamic> json) {
    return SeniorOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: SeniorOfferKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SeniorOfferKind.walk,
      ),
      contact: json['contact'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      wantsHelp: json['wantsHelp'] as bool? ?? false,
    );
  }

  static List<SeniorOffer> seeded() => const [
    SeniorOffer(
      id: 'senior-walk',
      title: 'Spacer sąsiedzki po południu',
      description: 'Krótki spacer wokół bloku, spokojne tempo.',
      kind: SeniorOfferKind.walk,
      contact: '500 111 222',
      authorName: 'Pani Halina',
      subDistrict: 'Olechów',
      wantsHelp: true,
    ),
    SeniorOffer(
      id: 'senior-chess',
      title: 'Wspólna kawa i szachy',
      description: 'Ławka przy klatce, herbata we własnym zakresie.',
      kind: SeniorOfferKind.coffeeChess,
      contact: 'Klatka II, dzwonek 12',
      authorName: 'Pan Józef',
      subDistrict: 'Stary Widzew',
    ),
    SeniorOffer(
      id: 'senior-office',
      title: 'Pomoc w drobnych sprawach urzędowych',
      description: 'Profil zaufany, e-recepta, wniosek w mObywatel.',
      kind: SeniorOfferKind.officeHelp,
      contact: '502 333 444',
      authorName: 'Sąsiadka z Janowa',
      subDistrict: 'Janów',
      wantsHelp: true,
    ),
    SeniorOffer(
      id: 'senior-help',
      title: 'Chętnie pomogę seniorom w okolicy',
      description: 'Zakupy, rozmowa, proste sprawy w telefonie.',
      kind: SeniorOfferKind.volunteer,
      contact: '501 222 333',
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
    ),
  ];
}
