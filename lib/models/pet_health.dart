class PetVaccineReminder {
  final String id;
  final String petName;
  final String vaccine;
  final String dateLabel;
  final bool reminded;

  const PetVaccineReminder({
    required this.id,
    required this.petName,
    required this.vaccine,
    required this.dateLabel,
    this.reminded = false,
  });

  PetVaccineReminder copyWith({bool? reminded}) {
    return PetVaccineReminder(
      id: id,
      petName: petName,
      vaccine: vaccine,
      dateLabel: dateLabel,
      reminded: reminded ?? this.reminded,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'petName': petName,
    'vaccine': vaccine,
    'dateLabel': dateLabel,
    'reminded': reminded,
  };

  factory PetVaccineReminder.fromJson(Map<String, dynamic> json) {
    return PetVaccineReminder(
      id: json['id'] as String? ?? '',
      petName: json['petName'] as String? ?? '',
      vaccine: json['vaccine'] as String? ?? '',
      dateLabel: json['dateLabel'] as String? ?? '',
      reminded: json['reminded'] as bool? ?? false,
    );
  }

  static List<PetVaccineReminder> seeded() => const [
    PetVaccineReminder(
      id: 'vac-burek',
      petName: 'Burek',
      vaccine: 'Wścieklizna',
      dateLabel: '12.11.2026',
    ),
    PetVaccineReminder(
      id: 'vac-mruczek',
      petName: 'Mruczek',
      vaccine: 'Koci katar + wścieklizna',
      dateLabel: '3.12.2026',
    ),
  ];
}

class VetClinic {
  final String id;
  final String name;
  final String address;
  final String note;

  const VetClinic({
    required this.id,
    required this.name,
    required this.address,
    required this.note,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'note': note,
  };

  factory VetClinic.fromJson(Map<String, dynamic> json) {
    return VetClinic(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  static List<VetClinic> seeded() => const [
    VetClinic(
      id: 'vet-rokicinska',
      name: 'Gabinet przy Rokicińskiej',
      address: 'ul. Rokicińska, Widzew Wschód',
      note: 'Psy i koty, szczepienia bez kolejki do 10:00.',
    ),
    VetClinic(
      id: 'vet-olechow',
      name: 'Weterynarz Olechów',
      address: 'os. Olechów, przy przychodni',
      note: 'Dyżur weekendowy, papugi i króliki.',
    ),
    VetClinic(
      id: 'vet-janow',
      name: 'Przychodnia na Janowie',
      address: 'Janów, przy pętli',
      note: 'Chipowanie i paszporty UE.',
    ),
  ];
}
