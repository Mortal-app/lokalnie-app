class LockCareTip {
  final String id;
  final String title;
  final String body;
  final String authorName;

  const LockCareTip({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory LockCareTip.fromJson(Map<String, dynamic> json) {
    return LockCareTip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<LockCareTip> seeded() => const [
    LockCareTip(
      id: 'lc-wkla',
      title: 'Wymiana wkładki w drzwiach wejściowych',
      body:
          'Klucz w środku, śruba pod klamką. Pomogę na klatce — nowa wkładka 30/40.',
      authorName: 'Pan Marek',
    ),
    LockCareTip(
      id: 'lc-zaw',
      title: 'Zawiasy i WD-40 — nie lej do wkładki',
      body:
          'WD-40 na zawiasy, do zamka grafit. Przesmaruję wieczorem po pracy.',
      authorName: 'Arek',
    ),
  ];
}
