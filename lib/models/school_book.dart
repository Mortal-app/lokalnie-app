class SchoolBookListing {
  final String id;
  final String title;
  final String school;
  final String grade;
  final String terms;
  final String authorName;

  const SchoolBookListing({
    required this.id,
    required this.title,
    required this.school,
    required this.grade,
    required this.terms,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'school': school,
    'grade': grade,
    'terms': terms,
    'authorName': authorName,
  };

  factory SchoolBookListing.fromJson(Map<String, dynamic> json) {
    return SchoolBookListing(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      school: json['school'] as String? ?? 'Szkoła podstawowa 1',
      grade: json['grade'] as String? ?? 'klasa 4',
      terms: json['terms'] as String? ?? 'Wymiana',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<SchoolBookListing> seeded() => const [
    SchoolBookListing(
      id: 'sb-mat',
      title: 'Matematyka — podręcznik + ćwiczenia',
      school: 'Szkoła podstawowa 1',
      grade: 'klasa 5',
      terms: 'Wymiana',
      authorName: 'Mama Zosi',
    ),
    SchoolBookListing(
      id: 'sb-hist',
      title: 'Historia — klasa 7',
      school: 'Szkoła podstawowa 2',
      grade: 'klasa 7',
      terms: 'Odkup 15 zł',
      authorName: 'Tata Kuby',
    ),
    SchoolBookListing(
      id: 'sb-ang',
      title: 'Angielski — zeszyt ćwiczeń',
      school: 'szkoła podstawowa',
      grade: 'klasa 4',
      terms: 'Oddam',
      authorName: 'Sąsiadka',
    ),
  ];
}
