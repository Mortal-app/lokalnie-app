import 'dart:io';

import 'package:image/image.dart' as img;

class LocalImageCompressor {
  static const maxWidth = 1200;
  static const jpegQuality = 82;

  static Future<String> compressFile(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) return path;
      final decoded = img.decodeImage(await file.readAsBytes());
      if (decoded == null) return path;
      final resized = decoded.width <= maxWidth
          ? decoded
          : img.copyResize(
              decoded,
              width: maxWidth,
              interpolation: img.Interpolation.linear,
            );
      final jpeg = img.encodeJpg(resized, quality: jpegQuality);
      final directory = file.parent.path;
      final stem = file.uri.pathSegments.last.replaceAll(
        RegExp(r'\.[^.]+$'),
        '',
      );
      final out = File('$directory${Platform.pathSeparator}${stem}_w$maxWidth.jpg');
      await out.writeAsBytes(jpeg, flush: true);
      return out.path;
    } catch (_) {
      return path;
    }
  }
}
