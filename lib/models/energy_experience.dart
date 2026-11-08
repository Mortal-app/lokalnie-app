enum EnergyKind { pv, heatPump, subsidy }

extension EnergyKindX on EnergyKind {
  String get label => switch (this) {
    EnergyKind.pv => 'Fotowoltaika',
    EnergyKind.heatPump => 'Pompa ciepła',
    EnergyKind.subsidy => 'Dotacja / program',
  };
}

class EnergyExperience {
  final String id;
  final String title;
  final String body;
  final EnergyKind kind;
  final String area;
  final String authorName;

  const EnergyExperience({
    required this.id,
    required this.title,
    required this.body,
    required this.kind,
    required this.area,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'kind': kind.name,
    'area': area,
    'authorName': authorName,
  };

  factory EnergyExperience.fromJson(Map<String, dynamic> json) {
    return EnergyExperience(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      kind: EnergyKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EnergyKind.pv,
      ),
      area: json['area'] as String? ?? 'Olechów',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<EnergyExperience> seeded() => const [
    EnergyExperience(
      id: 'en-pv-olechow',
      title: '6 kWp na dachu szeregówki',
      body:
          'Na Olechowie falownik Huawei, orientacja południe. Latem zbędny prąd oddajemy, zimą dogrzewamy bojler.',
      kind: EnergyKind.pv,
      area: 'Olechów',
      authorName: 'Marek z szeregówki',
    ),
    EnergyExperience(
      id: 'en-hp-wschod',
      title: 'Pompa powietrze-woda zamiast gazu',
      body:
          'Widzew Wschód, dom z 2004. Po ociepleniu pompa 9 kW starcza do −12 °C. Bufor 200 l.',
      kind: EnergyKind.heatPump,
      area: 'Widzew Wschód',
      authorName: 'Kasia z Wschodu',
    ),
    EnergyExperience(
      id: 'en-dotacja',
      title: 'Czyste Powietrze — papiery',
      body:
          'Wniosek przez gminę, audyt obowiązkowy. Czas od złożenia do decyzji ok. 3 miesięcy.',
      kind: EnergyKind.subsidy,
      area: 'Olechów',
      authorName: 'Sąsiad z Olechowa',
    ),
  ];
}
