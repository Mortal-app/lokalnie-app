import 'package:flutter/material.dart';

/// Systemowy wstecz zamyka bieżącą trasę zamiast wychodzić z aplikacji.
///
/// [Navigator.maybePop] / [Navigator.canPop] honorują `canPop: false` i nic
/// nie robią — dlatego wymuszamy [Navigator.pop].
class RoutePopScope extends StatelessWidget {
  final Widget child;

  const RoutePopScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!navigator.canPop()) return;
        navigator.pop(result);
      },
      child: child,
    );
  }
}

/// Jawna strzałka powrotu: [Navigator.pop] albo własna akcja (filtr, landing).
class AppBarBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBarBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
