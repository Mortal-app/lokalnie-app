import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';
import 'firebase_session.dart';

/// Kolekcja `content_reports` — zgłoszenia nieodpowiednich treści.
class ContentReportsFirestore {
  static const collection = 'content_reports';

  static Future<bool> submit({
    required String announcementId,
    required String reason,
    String title = '',
  }) async {
    if (isFlutterWidgetTest) return true;
    final id = announcementId.trim();
    final why = reason.trim();
    if (id.isEmpty || why.isEmpty) return false;
    try {
      await FirebaseSession.ensureSignedIn();
      final uid = FirebaseSession.uid;
      if (uid.isEmpty) return false;
      await FirebaseFirestore.instance.collection(collection).add({
        'announcementId': id,
        'reason': why,
        'title': title,
        'reporterUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      PrivacyLog.debug('Content report OK $id');
      return true;
    } catch (error) {
      PrivacyLog.debug('Content report FAILED', error);
      return false;
    }
  }
}
