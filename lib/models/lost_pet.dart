enum LostPetKind { dog, cat }

extension LostPetKindX on LostPetKind {
  String get label => switch (this) {
    LostPetKind.dog => 'Pies',
    LostPetKind.cat => 'Kot',
  };
}

class LostPetAlert {
  final String id;
  final LostPetKind kind;
  final String title;
  final String photoNote;
  final String place;
  final String authorName;

  const LostPetAlert({
    required this.id,
    required this.kind,
    required this.title,
    required this.photoNote,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'photoNote': photoNote,
    'place': place,
    'authorName': authorName,
  };

  factory LostPetAlert.fromJson(Map<String, dynamic> json) {
    return LostPetAlert(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == LostPetKind.cat.name
          ? LostPetKind.cat
          : LostPetKind.dog,
      title: json['title'] as String? ?? '',
      photoNote: json['photoNote'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Opiekun',
    );
  }

  static List<LostPetAlert> seeded() => const [
    LostPetAlert(
      id: 'lp-pies',
      kind: LostPetKind.dog,
      title: 'Zagubiony pies, obroża czerwona',
      photoNote: 'Zdjęcie: kundel rudy, średni, przy bloku 8.',
      place: 'Olechów, kilka bloków od SP 141',
      authorName: 'Kasia',
    ),
    LostPetAlert(
      id: 'lp-kot',
      kind: LostPetKind.cat,
      title: 'Kot dachowiec — wyszedł na balkon',
      photoNote: 'Zdjęcie: szary pręgowany, biała łapka.',
      place: 'Widzew Wschód, klatka II',
      authorName: 'Arek',
    ),
  ];
}
