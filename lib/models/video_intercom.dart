class VideoIntercomTip {
  final String id;
  final String title;
  final String body;
  final String authorName;

  const VideoIntercomTip({
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

  factory VideoIntercomTip.fromJson(Map<String, dynamic> json) {
    return VideoIntercomTip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<VideoIntercomTip> seeded() => const [
    VideoIntercomTip(
      id: 'vi-pan',
      title: 'Panel wideo — ostrość i kąt kamery',
      body: 'Regulacja w skrzynce przy drzwiach klatki. Pomogę po 18.',
      authorName: 'Pan Marek',
    ),
    VideoIntercomTip(
      id: 'vi-uni',
      title: 'Unifon — słuchawka i otwieranie furtki',
      body: 'Kod dostępu do klatki w menu panelu. Nie resetuj bez zarządu.',
      authorName: 'Arek',
    ),
  ];
}
