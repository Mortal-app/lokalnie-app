class SoundAlertPrefs {
  final String soundId;
  final bool quietHoursEnabled;
  final int quietStartHour;
  final int quietEndHour;

  const SoundAlertPrefs({
    this.soundId = 'system',
    this.quietHoursEnabled = false,
    this.quietStartHour = 22,
    this.quietEndHour = 7,
  });

  static const catalog = [
    ('system', 'Sygnał systemowy'),
    ('bell', 'Dzwonek'),
    ('short', 'Krótki ton'),
    ('soft', 'Cichy sygnał'),
  ];

  String get soundLabel {
    for (final item in catalog) {
      if (item.$1 == soundId) return item.$2;
    }
    return catalog.first.$2;
  }

  String get quietHoursLabel =>
      '${quietStartHour.toString().padLeft(2, '0')}:00–'
      '${quietEndHour.toString().padLeft(2, '0')}:00';

  SoundAlertPrefs copyWith({
    String? soundId,
    bool? quietHoursEnabled,
    int? quietStartHour,
    int? quietEndHour,
  }) {
    return SoundAlertPrefs(
      soundId: soundId ?? this.soundId,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietStartHour: quietStartHour ?? this.quietStartHour,
      quietEndHour: quietEndHour ?? this.quietEndHour,
    );
  }

  Map<String, Object?> toJson() => {
    'soundId': soundId,
    'quietHoursEnabled': quietHoursEnabled,
    'quietStartHour': quietStartHour,
    'quietEndHour': quietEndHour,
  };

  factory SoundAlertPrefs.fromJson(Map<String, dynamic> json) {
    return SoundAlertPrefs(
      soundId: json['soundId'] as String? ?? 'system',
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietStartHour: json['quietStartHour'] as int? ?? 22,
      quietEndHour: json['quietEndHour'] as int? ?? 7,
    );
  }
}
