enum HandyJobKind { tap, lock, curtain, other }

extension HandyJobKindX on HandyJobKind {
  String get label => switch (this) {
    HandyJobKind.tap => 'Naprawa kranu',
    HandyJobKind.lock => 'Wymiana zamka',
    HandyJobKind.curtain => 'Montaż karnisza',
    HandyJobKind.other => 'Zgłoszenie',
  };
}

class HandyJob {
  final String id;
  final HandyJobKind kind;
  final String title;
  final String description;
  final String staircase;
  final String authorName;
  final bool done;

  const HandyJob({
    required this.id,
    required this.kind,
    required this.title,
    this.description = '',
    required this.staircase,
    required this.authorName,
    this.done = false,
  });

  HandyJob copyWith({bool? done}) {
    return HandyJob(
      id: id,
      kind: kind,
      title: title,
      description: description,
      staircase: staircase,
      authorName: authorName,
      done: done ?? this.done,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'description': description,
    'staircase': staircase,
    'authorName': authorName,
    'done': done,
  };

  factory HandyJob.fromJson(Map<String, dynamic> json) {
    return HandyJob(
      id: json['id'] as String? ?? '',
      kind: HandyJobKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => HandyJobKind.other,
      ),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      staircase: json['staircase'] as String? ?? 'Klatka I',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      done: json['done'] as bool? ?? false,
    );
  }

  static List<HandyJob> seeded() => const [
    HandyJob(
      id: 'hj-kran',
      kind: HandyJobKind.tap,
      title: 'Cieknący kran w kuchni — mogę wpaść wieczorem',
      description: 'Mogę wpaść wieczorem z kluczami i uszczelką.',
      staircase: 'Klatka II',
      authorName: 'Pan Marek, złota rączka',
    ),
    HandyJob(
      id: 'hj-zamek',
      kind: HandyJobKind.lock,
      title: 'Wymiana wkładki zamka po zgubieniu kluczy',
      description: 'Potrzebna szybka wymiana wkładki na klatce IV.',
      staircase: 'Klatka IV, Olechów',
      authorName: 'Arek',
    ),
  ];
}
