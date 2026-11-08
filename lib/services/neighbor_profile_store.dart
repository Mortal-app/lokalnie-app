import 'package:shared_preferences/shared_preferences.dart';

class NeighborProfileStore {
  static const avatarIndexKey = 'neighbor_avatar_index';
  static const avatarPhotoKey = 'neighbor_avatar_photo_path';
  static const locationVerifiedKey = 'location_verified_widzew';
  static const exploredDistrictsKey = 'explored_subdistricts';

  static Future<(int avatarIndex, bool locationVerified, String? photoPath)>
      load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final photo = preferences.getString(avatarPhotoKey);
      return (
        preferences.getInt(avatarIndexKey) ?? 0,
        preferences.getBool(locationVerifiedKey) ?? false,
        photo == null || photo.isEmpty ? null : photo,
      );
    } catch (_) {
      return (0, false, null);
    }
  }

  static Future<bool> saveAvatarIndex(int index) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return await preferences.setInt(avatarIndexKey, index);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveAvatarPhotoPath(String? path) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (path == null || path.isEmpty) {
        return await preferences.remove(avatarPhotoKey);
      }
      return await preferences.setString(avatarPhotoKey, path);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveLocationVerified(bool verified) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return await preferences.setBool(locationVerifiedKey, verified);
    } catch (_) {
      return false;
    }
  }

  static Future<List<String>> loadExploredDistricts() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getStringList(exploredDistrictsKey) ?? const [];
    } catch (_) {
      return const [];
    }
  }

  static Future<bool> saveExploredDistricts(List<String> districts) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return await preferences.setStringList(
        exploredDistrictsKey,
        districts,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<void> clear() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(avatarIndexKey);
      await preferences.remove(avatarPhotoKey);
      await preferences.remove(locationVerifiedKey);
      await preferences.remove(exploredDistrictsKey);
    } catch (_) {}
  }
}
