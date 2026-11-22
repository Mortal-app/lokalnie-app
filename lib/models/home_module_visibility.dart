class HomeModuleVisibility {
  final bool fachowcy;
  final bool zwierzaki;
  final bool oddamKupie;
  final bool dzikieZwierzeta;
  final bool jedzenie;
  final bool sasiedzi;
  final bool wydarzenia;
  final bool wiecej;

  const HomeModuleVisibility({
    this.fachowcy = true,
    this.zwierzaki = true,
    this.oddamKupie = true,
    this.dzikieZwierzeta = true,
    this.jedzenie = true,
    this.sasiedzi = true,
    this.wydarzenia = true,
    this.wiecej = true,
  });

  bool show(String tileId) => switch (tileId) {
    'Fachowcy' => fachowcy,
    'Zwierzaki' => zwierzaki,
    'Oddam/Kupię' => oddamKupie,
    'Dzikie zwierzęta' => dzikieZwierzeta,
    'Jedzenie' => jedzenie,
    'Sąsiedzi' => sasiedzi,
    'Wydarzenia' => wydarzenia,
    'Więcej' || 'Inne' => wiecej,
    _ => true,
  };

  HomeModuleVisibility copyWith({
    bool? fachowcy,
    bool? zwierzaki,
    bool? oddamKupie,
    bool? dzikieZwierzeta,
    bool? jedzenie,
    bool? sasiedzi,
    bool? wydarzenia,
    bool? wiecej,
  }) {
    return HomeModuleVisibility(
      fachowcy: fachowcy ?? this.fachowcy,
      zwierzaki: zwierzaki ?? this.zwierzaki,
      oddamKupie: oddamKupie ?? this.oddamKupie,
      dzikieZwierzeta: dzikieZwierzeta ?? this.dzikieZwierzeta,
      jedzenie: jedzenie ?? this.jedzenie,
      sasiedzi: sasiedzi ?? this.sasiedzi,
      wydarzenia: wydarzenia ?? this.wydarzenia,
      wiecej: wiecej ?? this.wiecej,
    );
  }

  Map<String, Object?> toJson() => {
    'fachowcy': fachowcy,
    'zwierzaki': zwierzaki,
    'oddamKupie': oddamKupie,
    'dzikieZwierzeta': dzikieZwierzeta,
    'jedzenie': jedzenie,
    'sasiedzi': sasiedzi,
    'wydarzenia': wydarzenia,
    'wiecej': wiecej,
  };

  factory HomeModuleVisibility.fromJson(Map<String, dynamic> json) {
    return HomeModuleVisibility(
      fachowcy: json['fachowcy'] as bool? ?? true,
      zwierzaki: json['zwierzaki'] as bool? ?? true,
      oddamKupie: json['oddamKupie'] as bool? ?? true,
      dzikieZwierzeta: json['dzikieZwierzeta'] as bool? ?? true,
      jedzenie: json['jedzenie'] as bool? ?? true,
      sasiedzi: json['sasiedzi'] as bool? ?? true,
      wydarzenia: json['wydarzenia'] as bool? ?? true,
      wiecej: json['wiecej'] as bool? ?? true,
    );
  }

  static const tileLabels = [
    ('Fachowcy', 'fachowcy'),
    ('Zwierzaki', 'zwierzaki'),
    ('Oddam/Kupię', 'oddamKupie'),
    ('Dzikie zwierzęta', 'dzikieZwierzeta'),
    ('Jedzenie', 'jedzenie'),
    ('Sąsiedzi', 'sasiedzi'),
    ('Wydarzenia', 'wydarzenia'),
    ('Inne', 'wiecej'),
  ];
}
