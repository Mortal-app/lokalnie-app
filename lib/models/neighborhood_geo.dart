import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import 'announcement.dart';

/// Współrzędne mikro-osiedli Widzewa, Olechowa i Janowa.
class NeighborhoodGeo {
  static const widzewCenter = LatLng(51.7478, 19.5405);

  static LatLng forSubDistrict(String subDistrict) => switch (subDistrict) {
    'Widzew Wschód' => const LatLng(51.7572, 19.5488),
    'Olechów' => const LatLng(51.7374, 19.5592),
    'Janów' => const LatLng(51.7506, 19.5284),
    'Stary Widzew' => const LatLng(51.7594, 19.5126),
    'Księży Młyn' => const LatLng(51.7518, 19.4788),
    _ => widzewCenter,
  };

  static double distanceKm(String fromDistrict, String toDistrict) {
    final from = forSubDistrict(fromDistrict);
    final to = forSubDistrict(toDistrict);
    const kmPerDegree = 111.32;
    final midLat =
        (from.latitude + to.latitude) / 2 * math.pi / 180;
    final dLat = (from.latitude - to.latitude) * kmPerDegree;
    final dLng =
        (from.longitude - to.longitude) * kmPerDegree * math.cos(midLat);
    return math.sqrt(dLat * dLat + dLng * dLng);
  }

  static double distanceSquared(String fromDistrict, String toDistrict) {
    final from = forSubDistrict(fromDistrict);
    final to = forSubDistrict(toDistrict);
    final dLat = from.latitude - to.latitude;
    final dLng = from.longitude - to.longitude;
    return dLat * dLat + dLng * dLng;
  }

  static bool isInWidzew(double latitude, double longitude) {
    final dLat = (latitude - widzewCenter.latitude) * 111.32;
    final midLat = (latitude + widzewCenter.latitude) / 2 * math.pi / 180;
    final dLng =
        (longitude - widzewCenter.longitude) * 111.32 * math.cos(midLat);
    return math.sqrt(dLat * dLat + dLng * dLng) <= 8;
  }

  static String nearestSubDistrict(double latitude, double longitude) {
    var best = Announcement.subDistricts.first;
    var bestDistance = double.infinity;
    for (final name in Announcement.subDistricts) {
      final pin = forSubDistrict(name);
      final dLat = pin.latitude - latitude;
      final dLng = pin.longitude - longitude;
      final distance = dLat * dLat + dLng * dLng;
      if (distance < bestDistance) {
        bestDistance = distance;
        best = name;
      }
    }
    return best;
  }

  static LatLng pointFor(Announcement announcement, int index) {
    final lat = announcement.latitude;
    final lng = announcement.longitude;
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    return forAnnouncement(announcement.subDistrict, index);
  }

  static LatLng forAnnouncement(String subDistrict, int index) {
    final base = forSubDistrict(subDistrict);
    final ring = index % 6;
    final angle = ring * 0.9;
    final distance = 0.0012 * ((index % 3) + 1);
    return LatLng(
      base.latitude + distance * (angle % 2 == 0 ? 1 : -0.7),
      base.longitude + distance * ((ring - 2.5) * 0.35),
    );
  }
}
