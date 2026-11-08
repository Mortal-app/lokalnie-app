class HomeSitRequest {
  final String id;
  final String title;
  final String whenLabel;
  final String authorName;
  final bool mail;
  final bool plants;

  const HomeSitRequest({
    required this.id,
    required this.title,
    required this.whenLabel,
    required this.authorName,
    this.mail = true,
    this.plants = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenLabel': whenLabel,
    'authorName': authorName,
    'mail': mail,
    'plants': plants,
  };

  factory HomeSitRequest.fromJson(Map<String, dynamic> json) {
    return HomeSitRequest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      mail: json['mail'] as bool? ?? true,
      plants: json['plants'] as bool? ?? true,
    );
  }

  static List<HomeSitRequest> seeded() => const [
    HomeSitRequest(
      id: 'hs-wakacje',
      title:
          'Szukam zaufanego sąsiada do wybrania poczty i podlania kwiatów podczas wyjazdu',
      whenLabel: '12–19.11, klatka II',
      authorName: 'Kasia',
    ),
  ];
}
