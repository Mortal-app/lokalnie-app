enum MpoDistrict { wschod, olechow }

extension MpoDistrictX on MpoDistrict {
  String get label => switch (this) {
    MpoDistrict.wschod => 'Widzew Wschód',
    MpoDistrict.olechow => 'Olechów',
  };
}

class MpoBulkySlot {
  final String id;
  final MpoDistrict district;
  final String street;
  final String whenText;
  final String note;
  final String authorName;

  const MpoBulkySlot({
    required this.id,
    required this.district,
    required this.street,
    required this.whenText,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'district': district.name,
    'street': street,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
  };

  factory MpoBulkySlot.fromJson(Map<String, dynamic> json) {
    return MpoBulkySlot(
      id: json['id'] as String? ?? '',
      district: json['district'] == MpoDistrict.olechow.name
          ? MpoDistrict.olechow
          : MpoDistrict.wschod,
      street: json['street'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<MpoBulkySlot> seeded() => const [
    MpoBulkySlot(
      id: 'mpo-pusz',
      district: MpoDistrict.wschod,
      street: 'ul. Puszkina',
      whenText: 'Czwartek, wystawianie od 18:00',
      note: 'Kanapy i szafy — odbiór MPO rano.',
      authorName: 'Zarząd klatki',
    ),
    MpoBulkySlot(
      id: 'mpo-olech',
      district: MpoDistrict.olechow,
      street: 'ul. Zakładowa',
      whenText: 'Sobota 7:00–12:00',
      note: 'Stare meble przy śmietniku — nie wcześniej niż dzień odbioru.',
      authorName: 'Marek',
    ),
  ];
}
