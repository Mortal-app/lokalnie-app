enum WinterHelpKind { snowCar, winterRide }

extension WinterHelpKindX on WinterHelpKind {
  String get label => switch (this) {
    WinterHelpKind.snowCar => 'Odśnieżanie auta',
    WinterHelpKind.winterRide => 'Zimowy dojazd',
  };
}

class WinterHelpOffer {
  final String id;
  final WinterHelpKind kind;
  final String title;
  final String whenLabel;
  final String authorName;

  const WinterHelpOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'authorName': authorName,
  };

  factory WinterHelpOffer.fromJson(Map<String, dynamic> json) {
    return WinterHelpOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == WinterHelpKind.winterRide.name
          ? WinterHelpKind.winterRide
          : WinterHelpKind.snowCar,
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? 'Po opadach',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<WinterHelpOffer> seeded() => const [
    WinterHelpOffer(
      id: 'wh-snieg',
      kind: WinterHelpKind.snowCar,
      title: 'Odśnieżę dwa auta przy klatce III — wzajemnie',
      whenLabel: 'Rano po nocnych opadach',
      authorName: 'Tomek',
    ),
    WinterHelpOffer(
      id: 'wh-jazda',
      kind: WinterHelpKind.winterRide,
      title: 'Zimowy dojazd do centrum o 7:20 — łańcuchy w aucie',
      whenLabel: 'Pon–pt',
      authorName: 'Ola',
    ),
  ];
}
