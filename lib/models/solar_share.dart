enum SolarPostKind { tip, surplus, question }

extension SolarPostKindX on SolarPostKind {
  String get label => switch (this) {
    SolarPostKind.tip => 'Autokonsumpcja',
    SolarPostKind.surplus => 'Nadwyżka PV',
    SolarPostKind.question => 'Doświadczenie',
  };
}

class SolarSharePost {
  final String id;
  final SolarPostKind kind;
  final String title;
  final String body;
  final String authorName;

  const SolarSharePost({
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

  factory SolarSharePost.fromJson(Map<String, dynamic> json) {
    return SolarSharePost(
      id: json['id'] as String? ?? '',
      kind: SolarPostKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SolarPostKind.tip,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SolarSharePost> seeded() => const [
    SolarSharePost(
      id: 'pv-pralka',
      kind: SolarPostKind.tip,
      title: 'Pralka i bojler w szczycie produkcji',
      body:
          'Na dachu 4 kWp — pranie i grzanie wody 11:00–14:00, mniej oddajemy do sieci.',
      authorName: 'Arek, Olechów',
    ),
    SolarSharePost(
      id: 'pv-nad',
      kind: SolarPostKind.surplus,
      title: 'Południe — nadwyżka, sąsiad może odpalić zmywarkę',
      body: 'Mikroinstalacja na bloku, chętnie wymienię doświadczenia z licznikiem.',
      authorName: 'Basia',
    ),
  ];
}
