/// Czytelne komunikaty błędów chmury — bez surowych wyjątków w UI.
class CloudErrorMessages {
  static const photoFailed =
      'Nie udało się wysłać zdjęcia. Ogłoszenie zapisze lokalną kopię.';
  static const dataFailed =
      'Nie udało się wysłać danych. Spróbuj ponownie za chwilę.';
  static const permissionDenied =
      'Brak uprawnień do zapisu. Sprawdź logowanie i spróbuj ponownie.';
  static const offline =
      'Brak połączenia z serwerem. Dane zostają zapisane na urządzeniu.';
  static const reportFailed =
      'Nie udało się wysłać zgłoszenia. Spróbuj ponownie za chwilę.';
  static const deleteFailed =
      'Nie udało się usunąć wpisu z chmury. Spróbuj ponownie.';

  static String from(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('permission-denied') ||
        text.contains('permission_denied') ||
        text.contains('permission denied') ||
        text.contains('unauthorized')) {
      return permissionDenied;
    }
    if (text.contains('unavailable') ||
        text.contains('network') ||
        text.contains('socket') ||
        text.contains('hostname') ||
        text.contains('failed host lookup') ||
        text.contains('offline') ||
        text.contains('unknownhost')) {
      return offline;
    }
    if (text.contains('unauthorized') || text.contains('unauthenticated')) {
      return permissionDenied;
    }
    return dataFailed;
  }
}
