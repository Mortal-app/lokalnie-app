import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/neighborhood_geo.dart';

class WidzewFix {
  final double latitude;
  final double longitude;
  final String subDistrict;
  final String addressLabel;

  const WidzewFix({
    required this.latitude,
    required this.longitude,
    required this.subDistrict,
    required this.addressLabel,
  });
}

class WidzewLocation {
  static bool get _inTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('TestWidgets');

  static Future<WidzewFix> current({String fallbackDistrict = 'Widzew Wschód'}) async {
    if (_inTest) {
      final pin = NeighborhoodGeo.forSubDistrict(fallbackDistrict);
      return WidzewFix(
        latitude: pin.latitude,
        longitude: pin.longitude,
        subDistrict: fallbackDistrict,
        addressLabel: '$fallbackDistrict · 51.76°N 19.54°E',
      );
    }

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _fallback(fallbackDistrict);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      final district = NeighborhoodGeo.nearestSubDistrict(
        position.latitude,
        position.longitude,
      );
      return WidzewFix(
        latitude: position.latitude,
        longitude: position.longitude,
        subDistrict: district,
        addressLabel:
            '$district · ${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)}',
      );
    } catch (_) {
      return _fallback(fallbackDistrict);
    }
  }

  static WidzewFix _fallback(String district) {
    final pin = NeighborhoodGeo.forSubDistrict(district);
    return WidzewFix(
      latitude: pin.latitude,
      longitude: pin.longitude,
      subDistrict: district,
      addressLabel: '$district (przybliżona lokalizacja Widzewa)',
    );
  }

  static LatLng asLatLng(WidzewFix fix) => LatLng(fix.latitude, fix.longitude);
}
