enum BookGenre { literature, crime, children, textbook }

enum BookOfferTerms { exchange, free, lend }

extension BookGenreX on BookGenre {
  String get label => switch (this) {
    BookGenre.literature => 'Literatura',
    BookGenre.crime => 'Kryminały',
    BookGenre.children => 'Dla dzieci',
    BookGenre.textbook => 'Podręczniki',
  };
}

extension BookOfferTermsX on BookOfferTerms {
  String get label => switch (this) {
    BookOfferTerms.exchange => 'Wymienię na inną',
    BookOfferTerms.free => 'Oddam za darmo',
    BookOfferTerms.lend => 'Pożyczę',
  };
}

class BookOffer {
  final String id;
  final String title;
  final String author;
  final BookGenre genre;
  final BookOfferTerms terms;
  final String ownerName;
  final String subDistrict;
  final String note;

  const BookOffer({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.terms,
    required this.ownerName,
    required this.subDistrict,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'genre': genre.name,
    'terms': terms.name,
    'ownerName': ownerName,
    'subDistrict': subDistrict,
    'note': note,
  };

  factory BookOffer.fromJson(Map<String, dynamic> json) {
    return BookOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      genre: BookGenre.values.firstWhere(
        (item) => item.name == json['genre'],
        orElse: () => BookGenre.literature,
      ),
      terms: BookOfferTerms.values.firstWhere(
        (item) => item.name == json['terms'],
        orElse: () => BookOfferTerms.exchange,
      ),
      ownerName: json['ownerName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      note: json['note'] as String? ?? '',
    );
  }

  static List<BookOffer> seeded() => [
    BookOffer(
      id: 'book-lem',
      title: 'Solaris',
      author: 'Stanisław Lem',
      genre: BookGenre.literature,
      terms: BookOfferTerms.exchange,
      ownerName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      note: 'Chętnie wymienie na inną fantastykę.',
    ),
    BookOffer(
      id: 'book-crime',
      title: 'Ziarno prawdy',
      author: 'Zygmunt Miłoszewski',
      genre: BookGenre.crime,
      terms: BookOfferTerms.lend,
      ownerName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
      note: 'Na dwa tygodnie, odbiór w okolicy.',
    ),
    BookOffer(
      id: 'book-kids',
      title: 'Miś Uszatek – przygody',
      author: 'Czesław Janczarski',
      genre: BookGenre.children,
      terms: BookOfferTerms.free,
      ownerName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      note: 'Po naszym maluchu, stan dobry.',
    ),
    BookOffer(
      id: 'book-math',
      title: 'Matematyka – klasa 7',
      author: 'Podręcznik szkolny',
      genre: BookGenre.textbook,
      terms: BookOfferTerms.free,
      ownerName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
    ),
  ];
}
