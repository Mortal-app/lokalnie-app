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
        Navigator.of(context).pop(result);
      },
      child: child,
    );
  }
}
