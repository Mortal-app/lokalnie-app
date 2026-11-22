import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_info.dart';
import '../models/announcement.dart';
import 'privacy_log.dart';

class NeighborContact {
  static const messageSent = 'Wiadomość do sąsiada została wysłana.';
  static const callOrSmsStarted =
      'Łączenie z numerem sąsiada (połączenie / SMS).';
  static const outdatedReported = 'Zgłoszono ogłoszenie jako nieaktualne.';
  static const phoneCopied = 'Skopiowano numer telefonu';
  static const emailCopied = 'Skopiowano adres e-mail';

  static final _emailPattern = RegExp(
    r'[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}',
    caseSensitive: false,
  );
  static final _phonePattern = RegExp(
    r'(?:\+48[\s\-]?|0)?(?:\d[\s\-]?){8,11}\d',
  );

  static void sendMessage(BuildContext context) {
    _showSnackBar(context, messageSent);
  }

  static void callOrSms(BuildContext context) {
    unawaited(copyAndCall(context, AppInfo.adminPhone));
  }

  static Future<void> copyAndCall(BuildContext context, String phone) async {
    try {
      await Clipboard.setData(ClipboardData(text: phone));
    } catch (_) {}
    if (context.mounted) {
      _showSnackBar(context, phoneCopied);
    }
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    try {
      await launchUrl(uri);
    } catch (error) {
      PrivacyLog.debug('Nie udało się wywołać numeru', error);
      if (!context.mounted) return;
      _showSnackBar(context, callOrSmsStarted);
    }
  }

  static Future<void> copyAndEmail(BuildContext context, String email) async {
    try {
      await Clipboard.setData(ClipboardData(text: email));
    } catch (_) {}
    if (context.mounted) {
      _showSnackBar(context, emailCopied);
    }
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(uri);
    } catch (error) {
      PrivacyLog.debug('Nie udało się otworzyć e-maila', error);
    }
  }

  static Future<void> callNumber(BuildContext context, String phone) async {
    return copyAndCall(context, phone);
  }

  static String listingMessage(Announcement announcement) {
    return 'Cześć! Piszę z aplikacji Lokalnie w sprawie ogłoszenia '
        '„${announcement.title}”. Czy nadal jest aktualne?';
  }

  static String _digits(String phone) =>
      phone.replaceAll(RegExp(r'[^0-9+]'), '');

  static Future<void> sendSmsToNumber(
    BuildContext context,
    String phone, {
    String body = 'Cześć! Piszę z aplikacji Lokalnie.',
  }) async {
    final digits = _digits(phone);
    final uri = Uri.parse(
      'sms:$digits?body=${Uri.encodeComponent(body)}',
    );
    try {
      final launched = await launchUrl(uri);
      if (launched) return;
    } catch (error) {
      PrivacyLog.debug('Nie udało się otworzyć SMS', error);
    }
    if (!context.mounted) return;
    try {
      await Clipboard.setData(ClipboardData(text: body));
    } catch (_) {}
    if (context.mounted) {
      _showSnackBar(context, 'Skopiowano treść SMS do schowka');
    }
  }

  static Future<void> sendSms(
    BuildContext context,
    Announcement announcement,
  ) async {
    return sendSmsToNumber(
      context,
      phonesIn(announcement).first,
      body: listingMessage(announcement),
    );
  }

  static Future<void> sendWhatsApp(
    BuildContext context,
    Announcement announcement,
  ) async {
    final raw = _digits(phonesIn(announcement).first).replaceAll('+', '');
    final body = listingMessage(announcement);
    final uri = Uri.parse(
      'https://wa.me/$raw?text=${Uri.encodeComponent(body)}',
    );
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    } catch (error) {
      PrivacyLog.debug('Nie udało się otworzyć WhatsApp', error);
    }
    if (!context.mounted) return;
    try {
      await Clipboard.setData(ClipboardData(text: body));
    } catch (_) {}
    if (context.mounted) {
      _showSnackBar(context, 'Skopiowano wiadomość do WhatsApp');
    }
  }

  static void reportOutdated(BuildContext context) {
    _showSnackBar(context, outdatedReported);
  }

  static List<String> phonesIn(
    Announcement announcement, {
    bool fallback = true,
  }) {
    final haystack = '${announcement.title} ${announcement.description}';
    final found = _phonePattern
        .allMatches(haystack)
        .map((match) => match.group(0)!.trim())
        .where((value) => value.replaceAll(RegExp(r'\D'), '').length >= 9)
        .toSet()
        .toList();
    if (found.isNotEmpty) return found;
    return fallback ? const [AppInfo.adminPhone] : const [];
  }

  static List<String> emailsIn(
    Announcement announcement, {
    bool fallback = true,
  }) {
    final haystack = '${announcement.title} ${announcement.description}';
    final found = _emailPattern
        .allMatches(haystack)
        .map((match) => match.group(0)!)
        .toSet()
        .toList();
    if (found.isNotEmpty) return found;
    return fallback ? const [AppInfo.adminEmail] : const [];
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
