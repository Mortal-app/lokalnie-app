enum DigitalHelpKind { smartphone, trustedProfile, cityApps }

extension DigitalHelpKindX on DigitalHelpKind {
  String get label => switch (this) {
    DigitalHelpKind.smartphone => 'Obsługa smartfona',
    DigitalHelpKind.trustedProfile => 'Profil zaufany',
    DigitalHelpKind.cityApps => 'Aplikacje miejskie',
  };
}

class DigitalHelpOffer {
  final String id;
  final DigitalHelpKind kind;
  final String title;
  final String whenLabel;
  final String helperName;

  const DigitalHelpOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.helperName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'helperName': helperName,
  };

  factory DigitalHelpOffer.fromJson(Map<String, dynamic> json) {
    return DigitalHelpOffer(
      id: json['id'] as String? ?? '',
      kind: DigitalHelpKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => DigitalHelpKind.smartphone,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? 'Po 17:00',
      helperName: json['helperName'] as String? ?? 'Sąsiad',
    );
  }

  static List<DigitalHelpOffer> seeded() => const [
    DigitalHelpOffer(
      id: 'dh-phone',
      kind: DigitalHelpKind.smartphone,
      title: 'Pokażę dziadkowi z klatki jak dzwonić i SMS',
      whenLabel: 'Wtorek i czwartek 18:00',
      helperName: 'Kuba, 16 lat',
    ),
    DigitalHelpOffer(
      id: 'dh-pz',
      kind: DigitalHelpKind.trustedProfile,
      title: 'Pomogę założyć profil zaufany',
      whenLabel: 'Sobota 11:00',
      helperName: 'Ania',
    ),
    DigitalHelpOffer(
      id: 'dh-app',
      kind: DigitalHelpKind.cityApps,
      title: 'Instalacja MPK i aplikacji urzędu',
      whenLabel: 'Po umówieniu',
      helperName: 'Tomek',
    ),
  ];
}
