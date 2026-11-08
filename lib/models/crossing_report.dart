enum CrossingIssue { dark, unlit, unsafe }

extension CrossingIssueX on CrossingIssue {
  String get label => switch (this) {
    CrossingIssue.dark => 'Ciemne przejście',
    CrossingIssue.unlit => 'Brak oświetlenia',
    CrossingIssue.unsafe => 'Niebezpieczne (ruch / widoczność)',
  };
}

class CrossingReport {
  final String id;
  final CrossingIssue issue;
  final String place;
  final String note;
  final String authorName;

  const CrossingReport({
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

  factory CrossingReport.fromJson(Map<String, dynamic> json) {
    return CrossingReport(
      id: json['id'] as String? ?? '',
      issue: CrossingIssue.values.firstWhere(
        (item) => item.name == json['issue'],
        orElse: () => CrossingIssue.unsafe,
      ),
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<CrossingReport> seeded() => const [
    CrossingReport(
      id: 'cr-pils',
      issue: CrossingIssue.unlit,
      place: 'al. Piłsudskiego / przy DH Widzew',
      note: 'Lampa nie świeci od tygodnia, przejście przy przystanku.',
      authorName: 'Kasia',
    ),
    CrossingReport(
      id: 'cr-rok',
      issue: CrossingIssue.dark,
      place: 'Rokicińska, przy szkole',
      note: 'Po 17:00 bardzo ciemno, kierowcy nie zwalniają.',
      authorName: 'Pan Marek',
    ),
  ];
}
