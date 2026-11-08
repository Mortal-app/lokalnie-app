enum NotificationRadius { streetOrDistrict, allWidzew, radius2km }

extension NotificationRadiusX on NotificationRadius {
  String get label => switch (this) {
    NotificationRadius.streetOrDistrict => 'Tylko moja ulica / moje osiedle',
    NotificationRadius.allWidzew => 'Cały Widzew',
    NotificationRadius.radius2km => 'Promień 2 km',
  };

  String get storageName => name;

  static NotificationRadius fromStorage(String? value) {
    return switch (value) {
      'streetOrDistrict' => NotificationRadius.streetOrDistrict,
      'radius2km' => NotificationRadius.radius2km,
      _ => NotificationRadius.allWidzew,
    };
  }
}

class NotificationCategoryFilter {
  static const sos = 'Alert SOS';
  static const garageSale = 'Wyprzedaż Garażowa';

  static const selectable = [sos, garageSale];
}
