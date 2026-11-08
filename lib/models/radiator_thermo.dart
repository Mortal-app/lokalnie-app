enum RadiatorKind { pin, bleed }

extension RadiatorKindX on RadiatorKind {
  String get label => switch (this) {
    RadiatorKind.pin => 'Iglica termostatu',
    RadiatorKind.bleed => 'Odpowietrzanie kaloryfera',
  };
}

class RadiatorThermoTip {
  final String id;
  final RadiatorKind kind;
  final String title;
  final String body;
  final String authorName;

  const RadiatorThermoTip({
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

  factory RadiatorThermoTip.fromJson(Map<String, dynamic> json) {
    return RadiatorThermoTip(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == RadiatorKind.bleed.name
          ? RadiatorKind.bleed
          : RadiatorKind.pin,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<RadiatorThermoTip> seeded() => const [
    RadiatorThermoTip(
      id: 'rt-igl',
      kind: RadiatorKind.pin,
      title: 'Zablokowana iglica w głowicy',
      body: 'Zdjąć głowicę, lekko wcisnąć trzpień. Pomogę po 18.',
      authorName: 'Pan Marek',
    ),
    RadiatorThermoTip(
      id: 'rt-pow',
      kind: RadiatorKind.bleed,
      title: 'Odpowietrzanie kaloryfera w bloku',
      body: 'Klucz do odpowietrznika i miska. Najpierw najwyższe piętro.',
      authorName: 'Arek',
    ),
  ];
}
