enum PetProKind { vet, groomer }

extension PetProKindX on PetProKind {
  String get label => switch (this) {
    PetProKind.vet => 'Weterynarz',
    PetProKind.groomer => 'Groomer / salon',
  };
}

class PetProReview {
  final String id;
  final PetProKind kind;
  final String name;
  final String place;
  final String review;
  final String authorName;

  const PetProReview({
    required this.id,
    required this.kind,
    required this.name,
    required this.place,
    required this.review,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'name': name,
    'place': place,
    'review': review,
    'authorName': authorName,
  };

  factory PetProReview.fromJson(Map<String, dynamic> json) {
    return PetProReview(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == PetProKind.groomer.name
          ? PetProKind.groomer
          : PetProKind.vet,
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      review: json['review'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Opiekun',
    );
  }

  static List<PetProReview> seeded() => const [
    PetProReview(
      id: 'pp-vet',
      kind: PetProKind.vet,
      name: 'Gabinet przy Piłsudskiego',
      place: 'Widzew Wschód',
      review: 'Szybka pomoc przy kleszczu, spokojne podejście do psów.',
      authorName: 'Ola',
    ),
    PetProReview(
      id: 'pp-groom',
      kind: PetProKind.groomer,
      name: 'Salon na Olechowie',
      place: 'Olechów',
      review: 'Strzyżenie yorka bez stresu, umówienie z dnia na dzień.',
      authorName: 'Kasia',
    ),
  ];
}
