import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/development_notice_store.dart';
import '../theme/widzew_colors.dart';
import '../utils/flutter_runtime.dart';

class DevelopmentNoticeDialog extends StatelessWidget {
  const DevelopmentNoticeDialog({super.key});

  static const titleText = 'Aplikacja w fazie rozwoju';
  static const bodyText =
      'Aplikacja jest w trakcie tworzenia i budowania lokalnej społeczności, dlatego obecnie nie ma jeszcze zbyt wielu ogłoszeń, ale niebawem będzie ich coraz więcej. Jeśli masz własne ogłoszenie, wstaw je i pomóż rozwijać naszą społeczność!';

  /// Gdy true, zamknięcie okna zapisuje się w SharedPreferences i kolejne
  /// starty je pomijają. Na czas wdrożenia zostawiamy false — okno przy
  /// każdym restarcie aplikacji.
  static const persistDismissal = false;

  static var _presenting = false;

  static Future<void> maybeShow(BuildContext context) async {
    if (isFlutterWidgetTest || _presenting) return;
    if (!context.mounted) return;
    _presenting = true;
    if (persistDismissal) {
      final seen = await DevelopmentNoticeStore.hasSeen();
      if (seen || !context.mounted) {
        _presenting = false;
        return;
      }
    } else {
      unawaited(DevelopmentNoticeStore.reset());
    }
    if (!context.mounted) {
      _presenting = false;
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (dialogContext) => const DevelopmentNoticeDialog(),
    );
    _presenting = false;
  }

  Future<void> _continue(BuildContext context) async {
    if (persistDismissal) {
      await DevelopmentNoticeStore.markSeen();
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && persistDismissal) {
          unawaited(DevelopmentNoticeStore.markSeen());
        }
      },
      child: Dialog(
        key: const ValueKey('development-notice'),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: WidzewColors.red.withValues(alpha: 0.12),
                child: const Text('🏠', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('devNoticeTitle'),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr('devNoticeBody'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const ValueKey('development-notice-continue'),
                onPressed: () => unawaited(_continue(context)),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: WidzewColors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.tr('devNoticeContinue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
