class StaircaseCodeNote {
  final String id;
  final String block;
  final String staircase;
  final String hint;

  const StaircaseCodeNote({
    required this.id,
    required this.block,
    required this.staircase,
    required this.hint,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'block': block,
    'staircase': staircase,
    'hint': hint,
  };

  factory StaircaseCodeNote.fromJson(Map<String, dynamic> json) {
    return StaircaseCodeNote(
      id: json['id'] as String? ?? '',
      block: json['block'] as String? ?? '',
      staircase: json['staircase'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
    );
  }

  static List<StaircaseCodeNote> seeded() => const [
    StaircaseCodeNote(
      id: 'sc-demo',
      block: 'Wpis demo (nie jest to kod z prawdziwej klatki)',
      staircase: 'Klatka — uzupełnia gospodarz',
      hint:
          'Po autoryzacji gospodarz wpisuje własną notatkę serwisową. Aplikacja nie podaje kodów obcych klatek.',
    ),
  ];
}
