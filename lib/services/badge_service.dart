import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../models/neighbor_badge.dart';
import '../utils/flutter_runtime.dart';

class BadgeIds {
  static const activeNeighbor = 'active_neighbor';
  static const verifiedNeighbor = 'verified_neighbor';
  static const gpsVerified = 'gps_verified';
  static const firstListing = 'first_listing';
  static const helpfulHand = 'helpful_hand';
  static const ecoResident = 'eco_resident';
  static const localExpert = 'local_expert';
  static const fastDeal = 'fast_deal';
  static const garageKing = 'garage_king';
  static const goldenHand = 'golden_hand';
  static const watchfulEye = 'watchful_eye';
  static const popularNeighbor = 'popular_neighbor';
}

class BadgeService {
  static const prefsKey = 'unlocked_badge_ids';

  static final Set<String> _unlocked = {};
  static var _loaded = false;

  static Set<String> get unlockedIds => Set.unmodifiable(_unlocked);

  static bool isUnlocked(String id) => _unlocked.contains(id);

  static Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getStringList(prefsKey) ?? const <String>[];
      _unlocked
        ..clear()
        ..addAll(stored);
    } catch (_) {
      _unlocked.clear();
    }
    _loaded = true;
  }

  static Future<List<String>> unlock(Iterable<String> ids) async {
    if (!_loaded) await load();
    final newly = <String>[];
    for (final id in ids) {
      if (id.isEmpty) continue;
      if (_unlocked.add(id)) newly.add(id);
    }
    if (newly.isNotEmpty) await _save();
    return newly;
  }

  static Future<void> revoke(Iterable<String> ids) async {
    if (!_loaded) await load();
    var changed = false;
    for (final id in ids) {
      if (_unlocked.remove(id)) changed = true;
    }
    if (changed) await _save();
  }

  static Future<void> clear() async {
    _unlocked.clear();
    _loaded = true;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(prefsKey);
    } catch (_) {}
  }

  static Future<void> _save() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setStringList(prefsKey, _unlocked.toList());
    } catch (_) {}
  }
}

class BadgeManager {
  static List<String> idsForAnnouncement({
    required Announcement item,
    required int createdCount,
  }) {
    final ids = <String>[];
    if (createdCount >= 1) ids.add(BadgeIds.firstListing);
    if (createdCount >= 5) ids.add(BadgeIds.localExpert);
    if (NeighborAchievements.isGarageKing(item)) ids.add(BadgeIds.garageKing);
    if (item.isHelp) ids.add(BadgeIds.helpfulHand);
    if (NeighborAchievements.isGoldenHand(item)) ids.add(BadgeIds.goldenHand);
    if (item.isFree) ids.add(BadgeIds.ecoResident);
    return ids;
  }

  static List<String> idsForHelpMessage(Announcement? related) {
    final ids = <String>[BadgeIds.helpfulHand];
    if (related != null && NeighborAchievements.isGoldenHand(related)) {
      ids.add(BadgeIds.goldenHand);
    }
    return ids;
  }

  static List<String> idsForResolved(Announcement item) {
    final ids = <String>[];
    if (NeighborAchievements.isFastDeal(item)) ids.add(BadgeIds.fastDeal);
    if (NeighborAchievements.isWatchfulEye(item)) ids.add(BadgeIds.watchfulEye);
    if (NeighborAchievements.isGoldenHand(item)) ids.add(BadgeIds.goldenHand);
    return ids;
  }

  static List<String> idsFromCurrentState({
    required int createdCount,
    required List<Announcement> ownAnnouncements,
    required bool locationVerified,
    required bool neighborTrusted,
    required bool helpedRepairJob,
    required bool solvedCityReport,
  }) {
    final ids = <String>[BadgeIds.activeNeighbor];
    if (createdCount >= 1 || ownAnnouncements.isNotEmpty) {
      ids.add(BadgeIds.firstListing);
    }
    if (createdCount >= 5 || ownAnnouncements.length >= 5) {
      ids.add(BadgeIds.localExpert);
    }
    if (locationVerified) ids.add(BadgeIds.gpsVerified);
    if (neighborTrusted) ids.add(BadgeIds.verifiedNeighbor);
    final achievements = NeighborAchievements.evaluate(
      ownAnnouncements: ownAnnouncements,
      helpedRepairJob: helpedRepairJob,
      solvedCityReport: solvedCityReport,
    );
    if (achievements.fastDeal) ids.add(BadgeIds.fastDeal);
    if (achievements.garageKing) ids.add(BadgeIds.garageKing);
    if (achievements.goldenHand) ids.add(BadgeIds.goldenHand);
    if (achievements.watchfulEye) ids.add(BadgeIds.watchfulEye);
    if (achievements.popularNeighbor) ids.add(BadgeIds.popularNeighbor);
    if (ownAnnouncements.any((item) => item.isHelp)) {
      ids.add(BadgeIds.helpfulHand);
    }
    if (ownAnnouncements.any((item) => item.isFree)) {
      ids.add(BadgeIds.ecoResident);
    }
    return ids;
  }

  static String displayName(BuildContext context, String id) {
    return switch (id) {
      BadgeIds.activeNeighbor => context.tr('activeNeighbor'),
      BadgeIds.verifiedNeighbor => context.tr('verifiedNeighbor'),
      BadgeIds.gpsVerified => context.tr('confirmedResident'),
      BadgeIds.firstListing => 'Pierwsze Ogłoszenie',
      BadgeIds.helpfulHand => context.tr('badgeHelpingTitle'),
      BadgeIds.ecoResident => context.tr('badgeEcoTitle'),
      BadgeIds.localExpert => context.tr('badgeExpertTitle'),
      BadgeIds.fastDeal => context.tr('badgeFastDealTitle'),
      BadgeIds.garageKing => context.tr('badgeGarageKingTitle'),
      BadgeIds.goldenHand => context.tr('badgeGoldenHandTitle'),
      BadgeIds.watchfulEye => context.tr('badgeWatchfulEyeTitle'),
      BadgeIds.popularNeighbor => context.tr('badgePopularTitle'),
      _ => id,
    };
  }

  static void showUnlockedSnackBar(
    BuildContext context, {
    required List<String> ids,
    VoidCallback? onSeeProfile,
  }) {
    if (ids.isEmpty || isFlutterWidgetTest) return;
    final names = ids.map((id) => displayName(context, id)).join(', ');
    final text = ids.length == 1
        ? context.tr('badgeUnlocked', {'name': names})
        : context.tr('badgeUnlockedMany', {'names': names});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const Icon(Icons.military_tech, color: Color(0xFFFFD54F)),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
        action: onSeeProfile == null
            ? null
            : SnackBarAction(
                label: context.tr('badgeSeeProfile'),
                onPressed: onSeeProfile,
              ),
      ),
    );
  }
}
