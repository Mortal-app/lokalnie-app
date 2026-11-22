import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/pro_subscription.dart';
import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';

/// Dokument `users/{uid}` — token FCM i metadane sesji urządzenia.
class UserSessionFirestore {
  static const collection = 'users';

  static Future<void> saveFcmToken({
    required String uid,
    required String token,
  }) async {
    if (isFlutterWidgetTest) return;
    final trimmedUid = uid.trim();
    final trimmedToken = token.trim();
    if (trimmedUid.isEmpty || trimmedToken.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection(collection).doc(trimmedUid).set(
        {
          'fcmToken': trimmedToken,
          'fcmUpdatedAt': FieldValue.serverTimestamp(),
          'platform': defaultTargetPlatform.name,
        },
        SetOptions(merge: true),
      );
      PrivacyLog.debug('FCM token zapisany uidLen=${trimmedUid.length}');
    } catch (error) {
      PrivacyLog.debug('FCM token save FAILED', error);
    }
  }

  static Future<void> saveProStatus({
    required String uid,
    required bool isPro,
    DateTime? expiryAt,
    String productId = ProProduct.id,
  }) async {
    if (isFlutterWidgetTest) return;
    final trimmedUid = uid.trim();
    if (trimmedUid.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection(collection).doc(trimmedUid).set(
        {
          'isPro': isPro,
          'proProductId': productId,
          'proExpiryAt': expiryAt?.toIso8601String(),
          'proUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      PrivacyLog.debug('PRO status zapisany isPro=$isPro');
    } catch (error) {
      PrivacyLog.debug('PRO status save FAILED', error);
    }
  }

  static Future<ProEntitlement?> readProStatus({required String uid}) async {
    if (isFlutterWidgetTest) return null;
    final trimmedUid = uid.trim();
    if (trimmedUid.isEmpty) return null;
    try {
      final snap = await FirebaseFirestore.instance
          .collection(collection)
          .doc(trimmedUid)
          .get();
      if (!snap.exists) return null;
      return ProEntitlement.fromUserDoc(snap.data());
    } catch (error) {
      PrivacyLog.debug('PRO status read FAILED', error);
      return null;
    }
  }
}
