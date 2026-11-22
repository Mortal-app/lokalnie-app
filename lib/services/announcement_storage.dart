import 'package:flutter/foundation.dart';

import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';
import 'local_image_compressor.dart';

class StorageUploadResult {
  final String? imageBase64;
  final String? errorMessage;

  const StorageUploadResult.ok(this.imageBase64) : errorMessage = null;
  const StorageUploadResult.fail(this.errorMessage) : imageBase64 = null;

  bool get isOk => imageBase64 != null && imageBase64!.isNotEmpty;
}

/// Miniaturka ogłoszenia jako Base64 do dokumentu Firestore (bez Storage).
class AnnouncementStorage {
  static Future<String?> upload({
    required String localPath,
    String? announcementId,
    String? ownerUid,
  }) async {
    final result = await uploadResult(localPath: localPath);
    return result.imageBase64;
  }

  static Future<StorageUploadResult> uploadResult({
    required String localPath,
    String? announcementId,
    String? ownerUid,
  }) async {
    if (isFlutterWidgetTest || kIsWeb) {
      return const StorageUploadResult.ok(null);
    }
    final path = localPath.trim();
    if (path.isEmpty) {
      return const StorageUploadResult.fail('Nie wybrano zdjęcia.');
    }
    try {
      final encoded = await LocalImageCompressor.encodeListingBase64(path);
      if (encoded == null || encoded.isEmpty) {
        return const StorageUploadResult.fail(
          'Nie udało się przygotować miniaturki. Ogłoszenie zapisze się bez zdjęcia.',
        );
      }
      PrivacyLog.debug('Listing thumbnail OK len=${encoded.length}');
      return StorageUploadResult.ok(encoded);
    } catch (error) {
      PrivacyLog.debug('Listing thumbnail FAILED', error);
      return const StorageUploadResult.fail(
        'Nie udało się przygotować miniaturki. Ogłoszenie zapisze się bez zdjęcia.',
      );
    }
  }
}
