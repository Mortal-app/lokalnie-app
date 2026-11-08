class StorageGuard {
  static const diskFullMessage =
      'Nie udało się zapisać danych. Sprawdź wolne miejsce na telefonie i spróbuj ponownie.';

  static Future<bool> run(Future<void> Function() write) async {
    try {
      await write();
      return true;
    } catch (_) {
      return false;
    }
  }
}
