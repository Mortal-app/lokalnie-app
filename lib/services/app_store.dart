import '../models/app_snapshot.dart';
import 'announcement_service.dart';
import 'storage_backend.dart';

export '../models/app_snapshot.dart';

abstract interface class AppStore {
  Future<AppSnapshot> load();
  Future<void> save(AppSnapshot snapshot);
  Future<void> clear();
}

class AppStoreFactory {
  static AppStore local() =>
      SharedPreferencesAppStore(backend: LocalPreferencesBackend());

  /// Punkt podmiany na Cloud Firestore po skonfigurowaniu Firebase.
  static AppStore cloud() =>
      SharedPreferencesAppStore(backend: FirestoreStorageBackend());
}

class SharedPreferencesAppStore implements AppStore {
  SharedPreferencesAppStore({StorageBackend? backend})
    : _service = AnnouncementService(
        backend: backend ?? LocalPreferencesBackend(),
      );

  final AnnouncementService _service;

  @override
  Future<AppSnapshot> load() => _service.load();

  @override
  Future<void> save(AppSnapshot snapshot) => _service.save(snapshot);

  @override
  Future<void> clear() => _service.save(AppSnapshot.initial());
}

class MemoryAppStore implements AppStore {
  MemoryAppStore([AppSnapshot? snapshot])
    : _snapshot = snapshot ?? AppSnapshot.initial();

  AppSnapshot _snapshot;

  @override
  Future<AppSnapshot> load() async => _snapshot;

  @override
  Future<void> save(AppSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clear() async {
    _snapshot = AppSnapshot.initial();
  }
}
