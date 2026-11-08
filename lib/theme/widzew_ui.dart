import 'package:flutter/material.dart';

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
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
    );
  }
}
