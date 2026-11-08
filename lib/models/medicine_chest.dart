class MedicineOffer {
  final String id;
  final String title;
  final String expiry;
  final String authorName;
  final bool sealed;

  const MedicineOffer({
    required this.id,
    required this.title,
    required this.expiry,
    required this.authorName,
    this.sealed = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'expiry': expiry,
    'authorName': authorName,
    'sealed': sealed,
  };

  factory MedicineOffer.fromJson(Map<String, dynamic> json) {
    return MedicineOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      sealed: json['sealed'] as bool? ?? true,
    );
  }

  static List<MedicineOffer> seeded() => const [
    MedicineOffer(
      id: 'md-plastry',
      title: 'Plastry jałowe — opakowanie zamknięte',
      expiry: '12.2027',
      authorName: 'Pani Krysia',
    ),
    MedicineOffer(
      id: 'md-wit',
      title: 'Witamina D (fabrycznie zamknięte) — oddam do punktu / sąsiada',
      expiry: '03.2027',
      authorName: 'Kasia',
    ),
  ];
}
