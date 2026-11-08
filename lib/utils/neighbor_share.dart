import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/announcement.dart';
import '../models/tradesperson_marketplace.dart';
import 'announcement_share.dart';
import 'flutter_runtime.dart';
import 'privacy_log.dart';

class NeighborShare {
  static bool get _isWidgetTest => isFlutterWidgetTest;

  static String inviteMessage({
    required String userName,
    required String subDistrict,
  }) {
    return '$userName zaprasza Cię do aplikacji Lokalnie Widzew '
        'na osiedlu $subDistrict.\n'
        'Tablica ogłoszeń Widzewa, Olechowa i Janowa:\n'
        'https://lokalniewidzew.app/zaproszenie';
  }

  static String tradespersonMessage(TradespersonListing listing) {
    return 'Polecam fachowca ${listing.displayName} — ${listing.trade} ${listing.subDistrict}.\n'
        '${listing.description}\n'
        'Lokalnie Widzew: https://lokalniewidzew.app/fachowiec/${listing.id}';
  }

  static String recommendMessage() {
    return 'Cześć! Polecam Ci Lokalnie Widzew — lokalną tablicę ogłoszeń '
        'sąsiadów z Widzewa, Olechowa i Janowa. Dołącz do społeczności:\n'
        'https://lokalniewidzew.app/zaproszenie';
  }

  static Future<void> shareText(
    BuildContext context, {
    required String text,
    required String subject,
    required String copiedMessage,
  }) async {
    if (!_isWidgetTest) {
      try {
        await SharePlus.instance.share(
          ShareParams(text: text, subject: subject),
        );
        if (!context.mounted) return;
        _snack(context, 'Otwarto menu udostępniania');
        return;
      } catch (error) {
        PrivacyLog.debug('Nie udało się otworzyć udostępniania', error);
      }
    }
    unawaited(
      Clipboard.setData(ClipboardData(text: text)).catchError((Object error) {
        PrivacyLog.debug('Nie udało się skopiować treści', error);
      }),
    );
    if (!context.mounted) return;
    _snack(context, copiedMessage);
  }

  static Future<void> share(
    BuildContext context,
    Announcement announcement, {
    required String copiedMessage,
  }) {
    return shareText(
      context,
      text: AnnouncementShare.clipboardText(announcement),
      subject: announcement.title,
      copiedMessage: copiedMessage,
    );
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
