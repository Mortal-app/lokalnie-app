enum EnergyRecipeKind { electric, heating, slabHeat }

extension EnergyRecipeKindX on EnergyRecipeKind {
  String get label => switch (this) {
    EnergyRecipeKind.electric => 'Oszczędność prądu',
    EnergyRecipeKind.heating => 'Ogrzewanie miejskie',
    EnergyRecipeKind.slabHeat => 'Ciepło w wielkiej płycie',
  };
}

class EnergyRecipe {
  final String id;
  final EnergyRecipeKind kind;
  final String title;
  final String body;
  final String authorName;

  const EnergyRecipe({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory EnergyRecipe.fromJson(Map<String, dynamic> json) {
    return EnergyRecipe(
      id: json['id'] as String? ?? '',
      kind: EnergyRecipeKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EnergyRecipeKind.electric,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<EnergyRecipe> seeded() => const [
    EnergyRecipe(
      id: 'er-okno',
      kind: EnergyRecipeKind.slabHeat,
      title: 'Uszczelki na ościeżnicach w wielkiej płycie',
      body:
          'Przeciąg przy płycie obniża komfort. Uszczelka + folia na parapecie zimą.',
      authorName: 'Pan Leszek',
    ),
    EnergyRecipe(
      id: 'er-zawor',
      kind: EnergyRecipeKind.heating,
      title: 'Zawory termostatyczne — nie na max',
      body: '3–4 na głowicy, wietrzenie krótko. Niższy rachunek za ciepło.',
      authorName: 'Basia',
    ),
  ];
}
