enum PlaygroundIssue { swing, surface, bench }

extension PlaygroundIssueX on PlaygroundIssue {
  String get label => switch (this) {
    PlaygroundIssue.swing => 'Uszkodzona huśtawka',
    PlaygroundIssue.surface => 'Zniszczona nawierzchnia',
    PlaygroundIssue.bench => 'Połamana ławeczka',
  };
}

class PlaygroundReport {
  final String id;
  final PlaygroundIssue issue;
  final String place;
  final String note;
  final String authorName;

  const PlaygroundReport({
    required this.id,
    required this.issue,
    required this.place,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'issue': issue.name,
    'place': place,
    'note': note,
    'authorName': authorName,
  };

  factory PlaygroundReport.fromJson(Map<String, dynamic> json) {
    return PlaygroundReport(
      id: json['id'] as String? ?? '',
      issue: PlaygroundIssue.values.firstWhere(
        (item) => item.name == json['issue'],
        orElse: () => PlaygroundIssue.swing,
      ),
      place: json['place'] as String? ?? 'Plac zabaw',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PlaygroundReport> seeded() => const [
    PlaygroundReport(
      id: 'py-swing',
      issue: PlaygroundIssue.swing,
      place: 'Plac przy SP 141, Olechów',
      note: 'Łańcuch przetarty, huśtawka kołysze się bokiem.',
      authorName: 'Mama Kuby',
    ),
    PlaygroundReport(
      id: 'py-gum',
      issue: PlaygroundIssue.surface,
      place: 'Plac przy Rokicińskiej',
      note: 'Dziura w gumie pod zjeżdżalnią.',
      authorName: 'Sąsiad z Wschodu',
    ),
  ];
}
