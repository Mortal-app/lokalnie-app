enum PetDonorKind { dog, cat }

extension PetDonorKindX on PetDonorKind {
  String get label => switch (this) {
    PetDonorKind.dog => 'Pies',
    PetDonorKind.cat => 'Kot',
  };
}

class PetBloodDonor {
  final String id;
  final PetDonorKind kind;
  final String petName;
  final String contact;
  final String note;
  final String authorName;

  const PetBloodDonor({
    required this.id,
    required this.kind,
    required this.petName,
    required this.contact,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'petName': petName,
    'contact': contact,
    'note': note,
    'authorName': authorName,
  };

  factory PetBloodDonor.fromJson(Map<String, dynamic> json) {
    return PetBloodDonor(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == PetDonorKind.cat.name
          ? PetDonorKind.cat
          : PetDonorKind.dog,
      petName: json['petName'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Opiekun',
    );
  }

  static List<PetBloodDonor> seeded() => const [
    PetBloodDonor(
      id: 'pb-burek',
      kind: PetDonorKind.dog,
      petName: 'Burek, 28 kg, zdrowy',
      contact: 'SMS do Kasi — klatka III',
      note: 'Dawca w nagłych wypadkach, po kwalifikacji wet.',
      authorName: 'Kasia',
    ),
    PetBloodDonor(
      id: 'pb-mruczek',
      kind: PetDonorKind.cat,
      petName: 'Mruczek, grupa A',
      contact: 'Przez aplikację',
      note: 'Kot indoor, ostatnie badania w maju.',
      authorName: 'Ania',
    ),
  ];
}
