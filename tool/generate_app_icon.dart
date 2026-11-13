import 'dart:io';

import 'package:image/image.dart';

/// Rysuje ikonę „L” tymi samymi proporcjami co [WidzewLMark],
/// z literą wyśrodkowaną w czerwonym kwadracie.
Image drawAppIcon(int size) {
  final red = ColorRgb8(0xD3, 0x2F, 0x2F);
  final white = ColorRgb8(255, 255, 255);
  final img = Image(width: size, height: size);
  fill(img, color: red);
  final thickness = size * 0.18;
  final barWidth = size * 0.44;
  final barHeight = size * 0.58;
  final left = (size - barWidth) / 2;
  final top = (size - barHeight) / 2 + size * 0.03;
  final radius = (size * 0.045).round().clamp(1, size);
  fillRect(
    img,
    x1: left.round(),
    y1: top.round(),
    x2: (left + thickness).round(),
    y2: (top + barHeight).round(),
    color: white,
    radius: radius,
  );
  fillRect(
    img,
    x1: left.round(),
    y1: (top + barHeight - thickness).round(),
    x2: (left + barWidth).round(),
    y2: (top + barHeight).round(),
    color: white,
    radius: radius,
  );
  return img;
}

void _writePng(String path, Image image) {
  File(path).writeAsBytesSync(encodePng(image));
}

void main() {
  _writePng('assets/branding/app_icon.png', drawAppIcon(1024));
  const mipmaps = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };
  for (final entry in mipmaps.entries) {
    final png = drawAppIcon(entry.value);
    final dir = 'android/app/src/main/res/${entry.key}';
    _writePng('$dir/ic_launcher.png', png);
    _writePng('$dir/ic_launcher_round.png', png);
  }
}
