import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/widzew_theme.dart';

/// Ciemny pas pod systemowym paskiem Androida + kontrast białych ikon.
class WidzewSystemUi extends StatelessWidget {
  final Widget child;

  const WidzewSystemUi({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final style = WidzewTheme.overlayStyleFor(Theme.of(context));
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navColor = style.systemNavigationBarColor ?? const Color(0xFF1A1A1A);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: Stack(
        children: [
          child,
          if (bottomInset > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: bottomInset,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: navColor,
                    border: Border(
                      top: BorderSide(
                        color: Color.lerp(navColor, Colors.white, 0.18)!,
                        width: 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
