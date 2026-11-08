import 'package:flutter/material.dart';

enum AppLocale { pl, uk, en }

extension AppLocaleX on AppLocale {
  Locale get locale => switch (this) {
    AppLocale.pl => const Locale('pl'),
    AppLocale.uk => const Locale('uk'),
    AppLocale.en => const Locale('en'),
  };

  String get label => switch (this) {
    AppLocale.pl => 'Polski',
    AppLocale.uk => 'Українська',
    AppLocale.en => 'English',
  };

  String get storageName => name;

  static AppLocale fromStorage(String? value) {
    return switch (value) {
      'uk' => AppLocale.uk,
      'en' => AppLocale.en,
      _ => AppLocale.pl,
    };
  }
}
