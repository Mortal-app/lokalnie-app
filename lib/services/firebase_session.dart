import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_options.dart';
import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';
import 'local_push_service.dart';
import 'push_navigation.dart';
import 'user_session_firestore.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PrivacyLog.debug(
    'FCM background ${message.messageId ?? ''} '
    '${message.notification?.title ?? ''}',
  );
}

/// Anonimowe Firebase Auth + podstawowe FCM przy starcie.
class FirebaseSession {
  static String _uid = '';
  static var _messagingReady = false;
  static Map<String, String>? _pendingOpen;
  static void Function(Map<String, String> data)? _onOpened;
  static StreamSubscription<String>? _registeredSub;
  static StreamSubscription<RemoteMessage>? _openedSub;
  static StreamSubscription<RemoteMessage>? _foregroundSub;

  static String get uid => _uid;

  static Future<void> ensureSignedIn() async {
    if (isFlutterWidgetTest) return;
    try {
      final auth = FirebaseAuth.instance;
      final existing = auth.currentUser;
      if (existing != null) {
        _uid = existing.uid;
      } else {
        final credential = await auth.signInAnonymously();
        _uid = credential.user?.uid ?? '';
      }
      PrivacyLog.debug(
        'Firebase Auth OK uid=${_uid.isEmpty ? 'brak' : _uid}',
      );
    } catch (error) {
      PrivacyLog.debug('Firebase Auth FAILED', error);
    }
  }

  static void attachNotificationHandler(
    void Function(Map<String, String> data)? handler,
  ) {
    _onOpened = handler;
    final pending = _pendingOpen;
    if (handler != null && pending != null) {
      _pendingOpen = null;
      handler(pending);
    }
  }

  static void deliverNotificationData(Map<String, String> data) {
    if (data.isEmpty) return;
    final handler = _onOpened;
    if (handler == null) {
      _pendingOpen = data;
      return;
    }
    handler(data);
  }

  static Future<void> initMessaging() async {
    if (isFlutterWidgetTest || _messagingReady) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await _registeredSub?.cancel();
      _registeredSub = messaging.onRegistered.listen((token) {
        PrivacyLog.debug('FCM init OK fidLen=${token.length}');
        unawaited(() async {
          await ensureSignedIn();
          await UserSessionFirestore.saveFcmToken(uid: _uid, token: token);
        }());
      });
      await messaging.register();
      await _foregroundSub?.cancel();
      _foregroundSub = FirebaseMessaging.onMessage.listen(_showForegroundMessage);
      await _openedSub?.cancel();
      _openedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
        deliverNotificationData(PushNavigation.fromRemoteData(message.data));
      });
      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        deliverNotificationData(PushNavigation.fromRemoteData(initial.data));
      }
      _messagingReady = true;
    } catch (error) {
      PrivacyLog.debug('FCM init FAILED', error);
    }
  }

  static void _showForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = PushNavigation.fromRemoteData(message.data);
    final payload = data.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    unawaited(
      LocalPushService.show(
        id: message.hashCode & 0x7fffffff,
        title: notification?.title ?? 'Lokalnie',
        body:
            notification?.body ??
            message.data['body']?.toString() ??
            'Nowe powiadomienie',
        payload: payload,
      ),
    );
  }
}
