class NeighborTemplate {
  final String id;
  final String title;
  final String body;

  const NeighborTemplate({
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
  };

  factory NeighborTemplate.fromJson(Map<String, dynamic> json) {
    return NeighborTemplate(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<NeighborTemplate> seeded() => const [
    NeighborTemplate(
      id: 'tpl-loan',
      title: 'Umowa użyczenia sprzętu',
      body:
          'Umowa użyczenia sprzętu (wzór sąsiedzki)\n\n'
          'Użyczający: ……………………  Adres: ……………………\n'
          'Biorący: ……………………  Adres: ……………………\n'
          'Przedmiot: ……………………  Stan: ……………………\n'
          'Termin zwrotu: ……………………\n'
          'Biorący zobowiązuje się zwrócić sprzęt w stanie niepogorszonym '
          'i pokryć szkodę wynikłą z winy biorącego.\n'
          'Data i podpisy: ……………………',
    ),
    NeighborTemplate(
      id: 'tpl-flood',
      title: 'Oświadczenie o zalaniu mieszkania',
      body:
          'Oświadczenie o zalaniu mieszkania (wzór)\n\n'
          'Ja, ……………………, zam. ……………………, oświadczam, że w dniu …………………… '
          'doszło do zalania lokalu …………………… z lokalu …………………….\n'
          'Zakres szkód: ……………………\n'
          'Proszę o oględziny i protokół.\n'
          'Data, podpis: ……………………',
    ),
    NeighborTemplate(
      id: 'tpl-coop',
      title: 'Zgłoszenie do spółdzielni',
      body:
          'Zgłoszenie do spółdzielni / wspólnoty (wzór)\n\n'
          'Adres lokalu: ……………………\n'
          'Temat: ……………………\n'
          'Opis usterki / prośby: ……………………\n'
          'Proszę o informację o terminie interwencji.\n'
          'Imię i nazwisko, telefon, data: ……………………',
    ),
  ];
}
