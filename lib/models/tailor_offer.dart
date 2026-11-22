enum TailorJob { sew, hemPants, zipper, repair }

extension TailorJobX on TailorJob {
  String get label => switch (this) {
    TailorJob.sew => 'Szycie',
    TailorJob.hemPants => 'Skracanie spodni',
    TailorJob.zipper => 'Wymiana zamka',
    TailorJob.repair => 'Drobna naprawa odzieży',
  };
}

class TailorOffer {
  final String id;
  final TailorJob job;
  final String title;
  final String staircase;
  final String authorName;
  final String note;

  const TailorOffer({
    required this.id,
    required this.job,
    required this.title,
    required this.staircase,
    required this.authorName,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'job': job.name,
    'title': title,
    'staircase': staircase,
    'authorName': authorName,
    'note': note,
  };

  factory TailorOffer.fromJson(Map<String, dynamic> json) {
    return TailorOffer(
      id: json['id'] as String? ?? '',
      job: TailorJob.values.firstWhere(
        (item) => item.name == json['job'],
        orElse: () => TailorJob.repair,
      ),
      title: json['title'] as String? ?? '',
      staircase: json['staircase'] as String? ?? 'Klatka I',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      note: json['note'] as String? ?? '',
    );
  }

  static List<TailorOffer> seeded() => const [
    TailorOffer(
      id: 'tl-spodnie',
      job: TailorJob.hemPants,
      title: 'Skracam spodnie w bloku — odbiór wieczorem',
      staircase: 'Klatka III, stare osiedle',
      authorName: 'Pani Zosia',
      note: 'Maszyna w mieszkaniu, 1–2 dni.',
    ),
    TailorOffer(
      id: 'tl-zamek',
      job: TailorJob.zipper,
      title: 'Wymiana zamków w kurtkach i spodniach',
      staircase: 'okolica, klatka IV',
      authorName: 'Pani Halina',
    ),
  ];
}
