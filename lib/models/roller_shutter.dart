class RollerShutterTip {
  final String id;
  final String title;
  final String body;
  final String authorName;

  const RollerShutterTip({
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

  factory RollerShutterTip.fromJson(Map<String, dynamic> json) {
    return RollerShutterTip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<RollerShutterTip> seeded() => const [
    RollerShutterTip(
      id: 'rs-panc',
      title: 'Regulacja pancerza rolety zewnętrznej',
      body: 'Luz na prowadnicach, nie smaruj na siłę. Pomogę z drabiną.',
      authorName: 'Pan Marek',
    ),
    RollerShutterTip(
      id: 'rs-tasm',
      title: 'Zerwana taśma zwijacza',
      body: 'Taśma 14 mm, wymiana przez skrzynkę. Mam zapas na klatce.',
      authorName: 'Arek',
    ),
  ];
}
