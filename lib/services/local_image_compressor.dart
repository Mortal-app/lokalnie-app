import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class LocalImageCompressor {
  static const maxWidth = 1200;
  static const jpegQuality = 82;
  static const listingMaxWidth = 400;
  static const listingMaxBytes = 150 * 1024;

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

  /// Miniaturka ogłoszenia: max 400 px szerokości i poniżej 150 KB JPEG.
  static Uint8List? compressListingBytes(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    var work = decoded.width <= listingMaxWidth
        ? decoded
        : img.copyResize(
            decoded,
            width: listingMaxWidth,
            interpolation: img.Interpolation.linear,
          );
    Uint8List? smallest;
    for (final quality in [68, 52, 38, 28, 18]) {
      final jpeg = Uint8List.fromList(img.encodeJpg(work, quality: quality));
      smallest = jpeg;
      if (jpeg.length <= listingMaxBytes) return jpeg;
    }
    if (work.width > 240) {
      work = img.copyResize(
        work,
        width: 240,
        interpolation: img.Interpolation.linear,
      );
      final jpeg = Uint8List.fromList(img.encodeJpg(work, quality: 18));
      smallest = jpeg;
      if (jpeg.length <= listingMaxBytes) return jpeg;
    }
    if (smallest != null && smallest.length <= listingMaxBytes) return smallest;
    return null;
  }

  static String? encodeListingBase64FromBytes(Uint8List bytes) {
    final jpeg = compressListingBytes(bytes);
    if (jpeg == null || jpeg.isEmpty) return null;
    return base64Encode(jpeg);
  }

  static Future<String?> encodeListingBase64(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) return null;
      return encodeListingBase64FromBytes(await file.readAsBytes());
    } catch (_) {
      return null;
    }
  }
}
