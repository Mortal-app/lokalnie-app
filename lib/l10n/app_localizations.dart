import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'app_strings.dart';

/// Centralny menedżer tłumaczeń. Zmiana [locale] wymusza przebudowę
/// wszystkich widgetów, które wołają [AppLocalizations.of].
class LocalizationService {
  LocalizationService(this.locale) : _strings = AppStrings(locale);

  final AppLocale locale;
  final AppStrings _strings;

  String t(String key, [Map<String, String> args = const {}]) =>
      _strings.t(key, args);

  String translate(String key, [Map<String, String> args = const {}]) =>
      t(key, args);
}

class AppLocalizations extends InheritedWidget {
  AppLocalizations({
    super.key,
    required AppLocale locale,
    required super.child,
  }) : service = LocalizationService(locale);

  final LocalizationService service;

  AppLocale get locale => service.locale;

  String t(String key, [Map<String, String> args = const {}]) =>
      service.t(key, args);

  String translate(String key, [Map<String, String> args = const {}]) =>
      service.translate(key, args);

  static final AppLocalizations _fallback = AppLocalizations(
    locale: AppLocale.pl,
    child: const SizedBox.shrink(),
  );

  static AppLocalizations of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocalizations>() ??
        _fallback;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocalizations>();
  }

  @override
  bool updateShouldNotify(AppLocalizations oldWidget) =>
      locale != oldWidget.locale;
}

extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String tr(String key, [Map<String, String> args = const {}]) =>
      AppLocalizations.of(this).t(key, args);
}
