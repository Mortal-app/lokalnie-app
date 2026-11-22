import 'package:flutter/material.dart';

import 'route_pop_scope.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder})
    : super(
        opaque: true,
        fullscreenDialog: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            RoutePopScope(child: builder(context)),
        transitionDuration: _duration,
        reverseTransitionDuration: _reverseDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );

  /// AppBar ma strzałkę wstecz nawet gdy [RoutePopScope] ustawia `canPop: false`.
  @override
  bool get impliesAppBarDismissal => true;

  static bool get _inTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('TestWidgets');

  static Duration get _duration =>
      _inTest ? Duration.zero : const Duration(milliseconds: 280);

  static Duration get _reverseDuration =>
      _inTest ? Duration.zero : const Duration(milliseconds: 220);
}
