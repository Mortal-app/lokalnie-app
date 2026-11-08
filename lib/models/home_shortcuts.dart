import 'home_module_visibility.dart';

class HomeShortcuts {
  final List<String> tileOrder;
  final List<String> pinnedIds;

  const HomeShortcuts({
    this.tileOrder = const [],
    this.pinnedIds = const [],
  });

  static List<String> get defaultTileOrder =>
      HomeModuleVisibility.tileLabels.map((item) => item.$1).toList();

  static const pinCatalog = [
    ('parking-mark', 'Linie parkingowe'),
    ('clothes-bin', 'Kontenery na odzież'),
    ('pitcher', 'Filtr dzbanka'),
  ];

  List<String> resolvedTileOrder() {
    final defaults = defaultTileOrder;
    if (tileOrder.isEmpty) return defaults;
    final seen = <String>{};
    final ordered = <String>[];
    for (final id in tileOrder) {
      if (defaults.contains(id) && seen.add(id)) ordered.add(id);
    }
    for (final id in defaults) {
      if (seen.add(id)) ordered.add(id);
    }
    return ordered;
  }

  Map<String, Object?> toJson() => {
    'tileOrder': tileOrder,
    'pinnedIds': pinnedIds,
  };

  factory HomeShortcuts.fromJson(Map<String, dynamic> json) {
    return HomeShortcuts(
      tileOrder: (json['tileOrder'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      pinnedIds: (json['pinnedIds'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }
}
