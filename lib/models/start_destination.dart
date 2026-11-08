enum StartDestination { home, map, sale, groups }

extension StartDestinationX on StartDestination {
  String get label => switch (this) {
    StartDestination.home => 'Główna',
    StartDestination.map => 'Mapa',
    StartDestination.sale => 'Wyprzedaż',
    StartDestination.groups => 'Grupy',
  };

  String get storageName => name;

  static StartDestination fromStorage(String? value) {
    return switch (value) {
      'map' => StartDestination.map,
      'sale' => StartDestination.sale,
      'groups' => StartDestination.groups,
      _ => StartDestination.home,
    };
  }
}
