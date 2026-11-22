/// Limity miniaturki ogłoszenia zapisywanej jako Base64 w Firestore.
class ImageUploadRules {
  static const maxBytes = 150 * 1024;
  static const maxSourceBytes = 5 * 1024 * 1024;
  static const maxWidth = 400;
  static const maxBase64Chars = 220000;
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const allowedContentTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ];

  static String extensionOf(String path) {
    final normalized = path.trim().toLowerCase().split('?').first;
    final dot = normalized.lastIndexOf('.');
    if (dot < 0 || dot == normalized.length - 1) return '';
    return normalized.substring(dot + 1);
  }

  static bool isAllowedExtension(String path) {
    return allowedExtensions.contains(extensionOf(path));
  }

  static String contentTypeFor(String path) {
    switch (extensionOf(path)) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  static String? validate({required String path, int? sizeBytes}) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      return 'Nie wybrano zdjęcia.';
    }
    if (!isAllowedExtension(trimmed)) {
      return 'Można dodać tylko zdjęcia JPG, PNG lub WebP.';
    }
    if (sizeBytes != null && sizeBytes <= 0) {
      return 'Nie udało się odczytać zdjęcia. Wybierz inny plik.';
    }
    if (sizeBytes != null && sizeBytes > maxSourceBytes) {
      return 'Zdjęcie jest za duże. Wybierz mniejszy plik.';
    }
    return null;
  }
}
