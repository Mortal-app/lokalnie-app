enum WorkshopToolKind { torque, solder, welder, charger }

extension WorkshopToolKindX on WorkshopToolKind {
  String get label => switch (this) {
    WorkshopToolKind.torque => 'Klucz dynamometryczny',
    WorkshopToolKind.solder => 'Lutownica',
    WorkshopToolKind.welder => 'Spawarka',
    WorkshopToolKind.charger => 'Prostownik',
  };
}

class WorkshopTool {
  final String id;
  final WorkshopToolKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const WorkshopTool({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  WorkshopTool copyWith({bool? borrowed}) {
    return WorkshopTool(
      id: id,
      kind: kind,
      title: title,
      owner: owner,
      borrowed: borrowed ?? this.borrowed,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'owner': owner,
    'borrowed': borrowed,
  };

  factory WorkshopTool.fromJson(Map<String, dynamic> json) {
    return WorkshopTool(
      id: json['id'] as String? ?? '',
      kind: WorkshopToolKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => WorkshopToolKind.torque,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Sąsiad',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<WorkshopTool> seeded() => const [
    WorkshopTool(
      id: 'wt-dyn',
      kind: WorkshopToolKind.torque,
      title: 'Klucz dynamometryczny 40–210 Nm',
      owner: 'Arek, garaż przy klatce I',
    ),
    WorkshopTool(
      id: 'wt-lut',
      kind: WorkshopToolKind.solder,
      title: 'Stacja lutownicza',
      owner: 'Tomek',
    ),
    WorkshopTool(
      id: 'wt-spaw',
      kind: WorkshopToolKind.welder,
      title: 'Spawarka MMA — po umowie',
      owner: 'Pan Józef',
    ),
    WorkshopTool(
      id: 'wt-pros',
      kind: WorkshopToolKind.charger,
      title: 'Prostownik samochodowy',
      owner: 'Klub garażowy',
    ),
  ];
}
