class HomeStatsConfig {
  final bool bannerEnabled;
  final String favoriteCategory;

  const HomeStatsConfig({
    this.bannerEnabled = true,
    this.favoriteCategory = 'Sąsiedzi',
  });

  HomeStatsConfig copyWith({bool? bannerEnabled, String? favoriteCategory}) {
    return HomeStatsConfig(
      bannerEnabled: bannerEnabled ?? this.bannerEnabled,
      favoriteCategory: favoriteCategory ?? this.favoriteCategory,
    );
  }

  Map<String, Object?> toJson() => {
    'bannerEnabled': bannerEnabled,
    'favoriteCategory': favoriteCategory,
  };

  factory HomeStatsConfig.fromJson(Map<String, dynamic> json) {
    return HomeStatsConfig(
      bannerEnabled: json['bannerEnabled'] as bool? ?? true,
      favoriteCategory: json['favoriteCategory'] as String? ?? 'Sąsiedzi',
    );
  }

  static const categories = [
    'Sąsiedzi',
    'Oddam/Kupię',
    'Wydarzenia',
  ];
}
