import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Lekkie powiadomienia systemowe. [LocalNotificationMock] zostaje
/// źródłem listy w aplikacji — ta warstwa tylko wypycha alert na telefon.
class LocalPushService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static var _ready = false;
  static var _enabled = true;
  static void Function(String payload)? onTap;

  static bool get _inTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('TestWidgets');

  static bool get enabled => _enabled;

  static Future<void> init() async {
    if (_inTest || _ready) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        onTap?.call(payload);
      },
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    _ready = true;
  }

  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    if (_inTest) return;
    if (enabled) return;
    await init();
    await _plugin.cancelAll();
  }

  static Future<void> show({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    if (_inTest || !_enabled) return;
    await init();
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'widzew_local',
          'Lokalnie',
          channelDescription: 'Czaty sąsiedzkie i alerty z okolicy',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
