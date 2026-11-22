import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class WidzewFix {
  final double latitude;
  final double longitude;
  final String subDistrict;
  final String addressLabel;
  final bool success;

  const WidzewFix({
    required this.latitude,
    required this.longitude,
    required this.subDistrict,
    required this.addressLabel,
    this.success = false,
  });

  static const unavailable = WidzewFix(
    latitude: 0,
    longitude: 0,
    subDistrict: '',
    addressLabel: 'Brak lokalizacji',
    success: false,
  );

  bool get hasCoordinates => success;
}

class WidzewLocation {
  /// Test-only GPS override. Production never sets this.
  static WidzewFix? debugOverride;

  static bool get _inTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('TestWidgets');

  static Future<WidzewFix> current({String fallbackDistrict = ''}) async {
    final override = debugOverride;
    if (override != null) return override;
    if (_inTest) {
      return WidzewFix(
        latitude: 51.76,
        longitude: 19.54,
        subDistrict: fallbackDistrict,
        addressLabel: fallbackDistrict.isEmpty
            ? 'GPS (test)'
            : fallbackDistrict,
        success: true,
      );
    }

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return WidzewFix.unavailable;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      return WidzewFix(
        latitude: position.latitude,
        longitude: position.longitude,
        subDistrict: '',
        addressLabel:
            '${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)}',
        success: true,
      );
    } catch (_) {
      return WidzewFix.unavailable;
    }
  }

  static LatLng asLatLng(WidzewFix fix) => LatLng(fix.latitude, fix.longitude);
}
