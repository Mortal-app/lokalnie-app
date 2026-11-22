import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:lokalnie_widzew/services/image_upload_rules.dart';
import 'package:lokalnie_widzew/services/local_image_compressor.dart';

void main() {
  test('accepts jpg png webp source files', () {
    expect(
      ImageUploadRules.validate(path: 'photo.jpg', sizeBytes: 1024),
      isNull,
    );
    expect(
      ImageUploadRules.validate(path: 'photo.PNG', sizeBytes: 2 * 1024 * 1024),
      isNull,
    );
    expect(
      ImageUploadRules.validate(path: 'shot.webp', sizeBytes: 800 * 1024),
      isNull,
    );
    expect(ImageUploadRules.contentTypeFor('a.png'), 'image/png');
    expect(ImageUploadRules.contentTypeFor('a.jpeg'), 'image/jpeg');
    expect(ImageUploadRules.maxWidth, 400);
    expect(ImageUploadRules.maxBytes, 150 * 1024);
  });

  test('rejects empty and non-image files in Polish', () {
    expect(ImageUploadRules.validate(path: '  '), 'Nie wybrano zdjęcia.');
    expect(
      ImageUploadRules.validate(path: 'notes.pdf', sizeBytes: 100),
      'Można dodać tylko zdjęcia JPG, PNG lub WebP.',
    );
  });

  test('listing thumbnail stays within 400px and 150 KB', () {
    final source = img.Image(width: 1600, height: 1200);
    img.fill(source, color: img.ColorRgb8(200, 40, 40));
    final jpeg = Uint8List.fromList(img.encodeJpg(source, quality: 95));
    final compressed = LocalImageCompressor.compressListingBytes(jpeg);
    expect(compressed, isNotNull);
    expect(compressed!.length, lessThanOrEqualTo(LocalImageCompressor.listingMaxBytes));
    final decoded = img.decodeImage(compressed);
    expect(decoded, isNotNull);
    expect(decoded!.width, lessThanOrEqualTo(LocalImageCompressor.listingMaxWidth));
    final encoded = LocalImageCompressor.encodeListingBase64FromBytes(jpeg);
    expect(encoded, isNotNull);
    expect(encoded!.length, lessThanOrEqualTo(ImageUploadRules.maxBase64Chars));
  });
}
