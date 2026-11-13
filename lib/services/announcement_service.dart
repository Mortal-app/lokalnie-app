import '../models/announcement.dart';
import '../models/app_snapshot.dart';
import 'storage_backend.dart';

/// Serwis domenowy nad [StorageBackend]. UI i [AppStore] nie znają
/// SharedPreferences ani Firestore — wystarczy podmienić backend.
class AnnouncementService {
  static const snapshotDocumentId = 'app_snapshot';

  AnnouncementService({required this._backend});

  final StorageBackend _backend;

  Future<AppSnapshot> load() async {
    final data = await _backend.read(snapshotDocumentId);
    if (data == null) {
      return AppSnapshot.initial();
    }
    try {
      return AppSnapshot.fromJson(data);
    } on FormatException {
      return AppSnapshot.initial();
    } on TypeError {
      return AppSnapshot.initial();
    }
  }

  Future<void> save(AppSnapshot snapshot) {
    return _backend.write(snapshotDocumentId, snapshot.toJson());
  }

  Future<List<Announcement>> loadAnnouncements() async {
    final snapshot = await load();
    return snapshot.announcements;
  }
}
