enum ApplianceKind { blender, toaster, other }

extension ApplianceKindX on ApplianceKind {
  String get label => switch (this) {
    ApplianceKind.blender => 'Blender',
    ApplianceKind.toaster => 'Toster',
    ApplianceKind.other => 'Inne drobne AGD',
  };
}

class SmallAppliance {
  final String id;
  final ApplianceKind kind;
  final String title;
  final String authorName;
  final bool forRepair;

  const SmallAppliance({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
    this.forRepair = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
    'forRepair': forRepair,
  };

  factory SmallAppliance.fromJson(Map<String, dynamic> json) {
    return SmallAppliance(
      id: json['id'] as String? ?? '',
      kind: ApplianceKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ApplianceKind.other,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      forRepair: json['forRepair'] as bool? ?? true,
    );
  }

  static List<SmallAppliance> seeded() => const [
    SmallAppliance(
      id: 'sa-blender',
      kind: ApplianceKind.blender,
      title: 'Blender nie kręci — kto zna się na elektronice?',
      authorName: 'Pani Halina',
    ),
    SmallAppliance(
      id: 'sa-toster',
      kind: ApplianceKind.toaster,
      title: 'Toster po wymianie grzałki — oddam dalej',
      authorName: 'Arek',
      forRepair: false,
    ),
  ];
}
