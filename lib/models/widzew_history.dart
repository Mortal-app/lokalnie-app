class HistoryStory {
  final String id;
  final String title;
  final String photoCaption;
  final String body;

  const HistoryStory({
    required this.id,
    required this.title,
    required this.photoCaption,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'photoCaption': photoCaption,
    'body': body,
  };

  factory HistoryStory.fromJson(Map<String, dynamic> json) {
    return HistoryStory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      photoCaption: json['photoCaption'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<HistoryStory> seeded() => const [
    HistoryStory(
      id: 'hist-wima',
      title: 'Zakłady WiMa',
      photoCaption: 'Stare zdjęcie: hale Wimy przy Widzewie',
      body:
          'Widzewska Manufaktura tkała historię dzielnicy. Hale i kominy nadały rytm życiu robotniczemu i nazwie osiedla.',
    ),
    HistoryStory(
      id: 'hist-km',
      title: 'Księży Młyn',
      photoCaption: 'Stare zdjęcie: familoki i bruk',
      body:
          'Księży Młyn to osada fabryczna Scheiblera: cegła, bruk i układ ulic, który wciąż czyta się w terenie.',
    ),
    HistoryStory(
      id: 'hist-blocks',
      title: 'Bloki i architektura osiedla',
      photoCaption: 'Stare zdjęcie: pierwsze klatki na Olechowie',
      body:
          'Wielka płyta na Widzewie-Wschodzie i Olechowie to planowane osiedla z zielenią między klatkami i szkołami w zasięgu spaceru.',
    ),
  ];
}

class HistoryQuizQuestion {
  final String prompt;
  final List<String> options;
  final int correctIndex;

  const HistoryQuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  static List<HistoryQuizQuestion> questions() => const [
    HistoryQuizQuestion(
      prompt: 'Co oznacza skrót WiMa?',
      options: [
        'Widzewska Manufaktura',
        'Wielka Magazynowa',
        'Wojewódzki Instytut Maszyn',
      ],
      correctIndex: 0,
    ),
    HistoryQuizQuestion(
      prompt: 'Księży Młyn kojzył przede wszystkim z:',
      options: [
        'portem lotniczym',
        'osadą fabryczną Scheiblera',
        'stadionem żużlowym',
      ],
      correctIndex: 1,
    ),
    HistoryQuizQuestion(
      prompt: 'Olechów i Widzew-Wschód to głównie:',
      options: [
        'średniowieczne mury',
        'osiedla z wielkiej płyty i zielenią między klatkami',
        'port rzeczny',
      ],
      correctIndex: 1,
    ),
  ];
}
