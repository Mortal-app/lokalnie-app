import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidzewUi {
  static const radius = 16.0;
  static const pad = 12.0;
  static const padWide = 16.0;

  static const borderRadius = BorderRadius.all(Radius.circular(radius));

  static const shape = RoundedRectangleBorder(borderRadius: borderRadius);

  static const insets = EdgeInsets.all(pad);
  static const insetsWide = EdgeInsets.all(padWide);
  static const buttonPadding = EdgeInsets.symmetric(
    horizontal: padWide,
    vertical: pad,
  );

  /// Dolny zapas list i formularzy, żeby treść i przyciski nie wchodziły
  /// pod pasek systemowy ani pływający przycisk akcji.
  static const scrollBottom = 80.0;
  static const fabScrollBottom = 120.0;
  static const listCacheExtent = ScrollCacheExtent.pixels(1000);
  static const listPhysics = AlwaysScrollableScrollPhysics(
    parent: ClampingScrollPhysics(),
  );

  static int imageCachePixels(BuildContext context, double logicalSize) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (logicalSize * dpr).round().clamp(32, 2048);
  }

  static const listInsets = EdgeInsets.fromLTRB(
    padWide,
    12,
    padWide,
    scrollBottom,
  );
  static const listInsetsWithFab = EdgeInsets.fromLTRB(
    padWide,
    12,
    padWide,
    fabScrollBottom,
  );

  static Widget safeFab(Widget fab) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: fab,
    );
  }

  static Widget? maybeSafeFab(Widget? fab) {
    if (fab == null) return null;
    return safeFab(fab);
  }

  /// Pełnoekranowa warstwa pod arkuszem `isScrollControlled`, żeby tap w
  /// zaciemnienie zamykał okno (sam barrier Fluttera tam nie dostaje hit-testu).
  static Widget barrierDismissibleSheet({
    required BuildContext context,
    required Widget child,
  }) {
    return SizedBox.expand(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).maybePop(),
        child: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    );
  }
}
