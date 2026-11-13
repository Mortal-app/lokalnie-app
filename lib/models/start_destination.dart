enum StartDestination { home, sale, groups }

extension StartDestinationX on StartDestination {
  String get label => switch (this) {
    StartDestination.home => 'Główna',
    StartDestination.sale => 'Wyprzedaż',
    StartDestination.groups => 'Grupy',
  };

  String get storageName => name;

  static StartDestination fromStorage(String? value) {
    return switch (value) {
      'sale' => StartDestination.sale,
      'groups' => StartDestination.groups,
      _ => StartDestination.home,
    };
  }
}
