import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart';

final _red = ColorRgba8(0xD3, 0x2F, 0x2F, 255);
final _white = ColorRgba8(255, 255, 255, 255);
final _clear = ColorRgba8(0, 0, 0, 0);

/// Ikona 1024×1024: czerwone tło, biała pinezka z domkiem.
Image drawAppIcon(int size) => _draw(size, background: _red);

/// Foreground adaptive icon: pinezka na przezroczystym tle (safe zone).
Image drawForeground(int size) => _draw(
  size,
  background: _clear,
  pinScale: 0.62,
);

/// Grafika splash: biała pinezka na przezroczystym tle.
Image drawSplash(int size) => _draw(size, background: _clear, pinScale: 0.72);

Image _draw(
  int size, {
  required ColorRgba8 background,
  double pinScale = 0.78,
}) {
  const scale = 2;
  final canvas = size * scale;
  final img = Image(width: canvas, height: canvas, numChannels: 4);
  fill(img, color: background);

  final cx = canvas / 2;
  final cy = canvas * 0.44;
  final radius = canvas * 0.18 * pinScale / 0.78;
  final tipY = cy + radius * 2.05;
  _fillPin(img, cx, cy, radius, tipY, _white);
  _fillHouse(img, cx, cy, radius, _red);

  return copyResize(
    img,
    width: size,
    height: size,
    interpolation: Interpolation.average,
  );
}

void _fillPin(
  Image img,
  double cx,
  double cy,
  double radius,
  double tipY,
  ColorRgba8 color,
) {
  fillCircle(
    img,
    x: cx.round(),
    y: cy.round(),
    radius: radius.round(),
    color: color,
    antialias: true,
  );
  final spread = radius * 0.82;
  fillPolygon(
    img,
    vertices: [
      Point(cx - spread, cy + radius * 0.28),
      Point(cx + spread, cy + radius * 0.28),
      Point(cx, tipY),
    ],
    color: color,
  );
  // Wygładź styki koła z trójkątem.
  fillCircle(
    img,
    x: cx.round(),
    y: (cy + radius * 0.22).round(),
    radius: (radius * 0.72).round(),
    color: color,
    antialias: true,
  );
}

void _fillHouse(Image img, double cx, double cy, double radius, ColorRgba8 color) {
  final half = radius * 0.38;
  final bodyTop = cy - radius * 0.04;
  final bodyBottom = cy + radius * 0.40;
  final bodyLeft = cx - half;
  final bodyRight = cx + half;
  fillPolygon(
    img,
    vertices: [
      Point(cx, cy - radius * 0.50),
      Point(bodyLeft - radius * 0.10, bodyTop + radius * 0.10),
      Point(bodyRight + radius * 0.10, bodyTop + radius * 0.10),
    ],
    color: color,
  );
  fillRect(
    img,
    x1: bodyLeft.round(),
    y1: bodyTop.round(),
    x2: bodyRight.round(),
    y2: bodyBottom.round(),
    color: color,
    radius: math.max(1, (radius * 0.04).round()),
  );
  final doorHalf = radius * 0.09;
  fillRect(
    img,
    x1: (cx - doorHalf).round(),
    y1: (bodyBottom - radius * 0.22).round(),
    x2: (cx + doorHalf).round(),
    y2: bodyBottom.round(),
    color: _white,
  );
}

void _writePng(String path, Image image) {
  File(path).parent.createSync(recursive: true);
  File(path).writeAsBytesSync(encodePng(image));
}

void main() {
  _writePng('assets/branding/app_icon.png', drawAppIcon(1024));
  _writePng('assets/branding/app_icon_foreground.png', drawForeground(1024));
  _writePng('assets/branding/splash.png', drawSplash(1024));
}
