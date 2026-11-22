import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement.dart';
import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';
import 'firebase_session.dart';

/// Kolekcja `announcements` — źródło tablicy w czasie rzeczywistym.
class AnnouncementsFirestore {
  static const collection = 'announcements';

  static CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection(collection);

  static Stream<List<Announcement>> watch({String? categoryEquals}) {
    if (isFlutterWidgetTest) return const Stream.empty();
    Query<Map<String, dynamic>> query = _col;
    final category = categoryEquals?.trim() ?? '';
    if (category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query
        .snapshots()
        .map((snapshot) {
          final items = <Announcement>[];
          for (final doc in snapshot.docs) {
            try {
              items.add(fromDoc(doc));
            } catch (error) {
              PrivacyLog.debug('Firestore skip ${doc.id}: $error');
            }
          }
          items.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
          return items;
        })
        .handleError((error, stackTrace) {
          PrivacyLog.debug('Firestore watch: $error');
        });
  }

  static Future<Announcement> upsert(Announcement announcement) async {
    final uid = FirebaseSession.uid;
    final withUid = announcement.copyWith(
      authorUid: announcement.authorUid.isNotEmpty
          ? announcement.authorUid
          : uid,
      category: Announcement.canonicalizeCategory(announcement.category),
      isMine: true,
    );
    final ref = withUid.id.isEmpty ? _col.doc() : _col.doc(withUid.id);
    await ref.set(toMap(withUid), SetOptions(merge: true));
    PrivacyLog.debug('Firestore announcement upsert ${ref.id}');
    return withUid.copyWith(id: ref.id, pendingSync: false);
  }

  static Future<void> delete(Announcement announcement) async {
    if (announcement.id.isEmpty) return;
    await _col.doc(announcement.id).delete();
  }

  static Announcement fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = doc.id;
    final published = data['publishedAt'];
    if (published is Timestamp) {
      data['publishedAt'] = published.toDate().toIso8601String();
    }
    final resolved = data['resolvedAt'];
    if (resolved is Timestamp) {
      data['resolvedAt'] = resolved.toDate().toIso8601String();
    }
    final item = Announcement.fromJson(data);
    final uid = FirebaseSession.uid;
    return item.copyWith(
      id: doc.id,
      isMine: item.authorUid.isNotEmpty && item.authorUid == uid,
    );
  }

  static Map<String, Object?> toMap(Announcement announcement) {
    final json = announcement.toJson();
    json.remove('isFavorite');
    json.remove('isLiked');
    json.remove('isMine');
    json.remove('isSupported');
    json.remove('myReaction');
    json.remove('imagePath');
    json['category'] = Announcement.canonicalizeCategory(announcement.category);
    final encoded = announcement.imageBase64;
    json['imageBase64'] = (encoded != null && encoded.isNotEmpty)
        ? encoded
        : null;
    final url = announcement.imageUrl;
    if (url != null &&
        (url.startsWith('http://') || url.startsWith('https://'))) {
      json['imageUrl'] = url;
    } else {
      json.remove('imageUrl');
    }
    json['authorUid'] = announcement.authorUid.isNotEmpty
        ? announcement.authorUid
        : FirebaseSession.uid;
    json['titleLower'] = announcement.title.toLowerCase();
    json['descriptionLower'] = announcement.description.toLowerCase();
    return json;
  }
}
