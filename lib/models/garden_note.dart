enum GardenNoteKind { water, sow, work }

extension GardenNoteKindX on GardenNoteKind {
  String get label => switch (this) {
    GardenNoteKind.water => 'Podlewanie ziół',
    GardenNoteKind.sow => 'Wysiew (klimat łódzki)',
    GardenNoteKind.work => 'Prace ogrodowe',
  };
}

class GardenNote {
  final String id;
  final GardenNoteKind kind;
  final String title;
  final String whenLabel;
  final String tip;

  const GardenNote({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.tip,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'tip': tip,
  };

  factory GardenNote.fromJson(Map<String, dynamic> json) {
    return GardenNote(
      id: json['id'] as String? ?? '',
      kind: GardenNoteKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => GardenNoteKind.work,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
    );
  }

  static List<GardenNote> seeded() => const [
    GardenNote(
      id: 'gn-bazylia',
      kind: GardenNoteKind.water,
      title: 'Balkon: bazylia i mięta',
      whenLabel: 'Co 2 dni, rano',
      tip: 'W Łodzi wiatr suszy doniczki — podlewaj częściej niż na ROD.',
    ),
    GardenNote(
      id: 'gn-rzodkiew',
      kind: GardenNoteKind.sow,
      title: 'Rzodkiewka i sałata',
      whenLabel: 'Marzec–kwiecień',
      tip: 'Klimat łódzki: osłona agrowłókniną przy przymrozkach do maja.',
    ),
    GardenNote(
      id: 'gn-prace',
      kind: GardenNoteKind.work,
      title: 'Przekopka i kompost',
      whenLabel: 'Październik',
      tip: 'Liście z klatki na kompost — nie do worka zmieszanego.',
    ),
  ];
}
