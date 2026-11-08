enum RetroPlatform { commodore, amiga, oldPc, console }

extension RetroPlatformX on RetroPlatform {
  String get label => switch (this) {
    RetroPlatform.commodore => 'Commodore',
    RetroPlatform.amiga => 'Amiga',
    RetroPlatform.oldPc => 'Stary PeCet',
    RetroPlatform.console => 'Retro-konsola',
  };
}

class RetroGamingEvent {
  final String id;
  final RetroPlatform platform;
  final String title;
  final String whenLabel;
  final String place;
  final String host;

  const RetroGamingEvent({
    required this.id,
    required this.platform,
    required this.title,
    required this.whenLabel,
    required this.place,
    required this.host,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'platform': platform.name,
    'title': title,
    'whenLabel': whenLabel,
    'place': place,
    'host': host,
  };

  factory RetroGamingEvent.fromJson(Map<String, dynamic> json) {
    return RetroGamingEvent(
      id: json['id'] as String? ?? '',
      platform: RetroPlatform.values.firstWhere(
        (item) => item.name == json['platform'],
        orElse: () => RetroPlatform.oldPc,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      host: json['host'] as String? ?? 'Sąsiad',
    );
  }

  static List<RetroGamingEvent> seeded() => const [
    RetroGamingEvent(
      id: 'rg-c64',
      platform: RetroPlatform.commodore,
      title: 'Wieczór Commodore 64 — gry z taśmy',
      whenLabel: 'Sobota 17:00',
      place: 'Świetlica, Stary Widzew',
      host: 'Pan Jacek',
    ),
    RetroGamingEvent(
      id: 'rg-amiga',
      platform: RetroPlatform.amiga,
      title: 'Turniej Amiga — Sensible Soccer',
      whenLabel: 'Niedziela 15:00',
      place: 'Klatka I, Olechów',
      host: 'Tomek',
    ),
  ];
}
