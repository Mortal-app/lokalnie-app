enum MicroBizKind { hair, beauty, electrician, plumber }

extension MicroBizKindX on MicroBizKind {
  String get label => switch (this) {
    MicroBizKind.hair => 'Fryzjerka mobilna',
    MicroBizKind.beauty => 'Kosmetyczka',
    MicroBizKind.electrician => 'Elektryk',
    MicroBizKind.plumber => 'Hydraulik',
  };
}

class MicroBusiness {
  final String id;
  final MicroBizKind kind;
  final String name;
  final String area;
  final List<String> reviews;

  const MicroBusiness({
    required this.id,
    required this.kind,
    required this.name,
    required this.area,
    this.reviews = const [],
  });

  MicroBusiness copyWith({List<String>? reviews}) {
    return MicroBusiness(
      id: id,
      kind: kind,
      name: name,
      area: area,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'name': name,
    'area': area,
    'reviews': reviews,
  };

  factory MicroBusiness.fromJson(Map<String, dynamic> json) {
    return MicroBusiness(
      id: json['id'] as String? ?? '',
      kind: MicroBizKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => MicroBizKind.plumber,
      ),
      name: json['name'] as String? ?? '',
      area: json['area'] as String? ?? 'Widzew',
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }

  static List<MicroBusiness> seeded() => const [
    MicroBusiness(
      id: 'mb-fryz',
      kind: MicroBizKind.hair,
      name: 'Ania — fryzura w domu',
      area: 'Olechów',
      reviews: ['Punktualna i spokojna z dziećmi.'],
    ),
    MicroBusiness(
      id: 'mb-hyd',
      kind: MicroBizKind.plumber,
      name: 'Pan Marek — hydraulik z klatki',
      area: 'Widzew Wschód',
      reviews: ['Wymienił syfon tego samego dnia.'],
    ),
  ];
}
