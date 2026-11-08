import 'package:image_picker/image_picker.dart';

import 'local_image_compressor.dart';

class AppImagePicker {
  const AppImagePicker();

  Future<String?> pickFromGallery() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: LocalImageCompressor.jpegQuality,
      maxWidth: LocalImageCompressor.maxWidth.toDouble(),
    );
    if (file == null) return null;
    return await LocalImageCompressor.compressFile(file.path);
  }

  Future<String?> pickFromCamera() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: LocalImageCompressor.jpegQuality,
        maxWidth: LocalImageCompressor.maxWidth.toDouble(),
      );
      if (file == null) return null;
      return await LocalImageCompressor.compressFile(file.path);
    } catch (_) {
      return await pickFromGallery();
    }
  }
}
