import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';

/// Jednorazowy zapis i odczyt testowego dokumentu Cloud Firestore.
class FirestorePing {
  static const collection = 'connection_tests';
  static const documentId = 'ping';

  static Future<void> run() async {
    if (kReleaseMode || isFlutterWidgetTest) return;
    try {
      final doc = FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId);
      final writtenAt = DateTime.now().toUtc().toIso8601String();
      await doc.set({
        'ok': true,
        'at': writtenAt,
        'source': 'lokalnie',
      });
      final snap = await doc.get();
      final data = snap.data();
      if (!snap.exists || data == null) {
        PrivacyLog.debug(
          'Firestore ping FAILED: brak dokumentu $collection/$documentId po zapisie',
        );
        return;
      }
      PrivacyLog.debug(
        'Firestore ping OK: zapis i odczyt $collection/$documentId at=${data['at']}',
      );
    } catch (error) {
      PrivacyLog.debug('Firestore ping FAILED', error);
    }
  }
}
