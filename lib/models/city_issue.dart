import 'package:flutter/material.dart';

import 'announcement.dart';

enum CityIssueKind { lighting, lostPet, renovation, other }

extension CityIssueX on Announcement {
  CityIssueKind get issueKind {
    final haystack = '$title $description $category'.toLowerCase();
    if (haystack.contains('oświetl') ||
        haystack.contains('oswietl') ||
        haystack.contains('lamp')) {
      return CityIssueKind.lighting;
    }
    if (haystack.contains('zwierz') ||
        haystack.contains('zgub') ||
        haystack.contains('pies') ||
        haystack.contains('kot')) {
      return CityIssueKind.lostPet;
    }
    if (haystack.contains('remont') ||
        haystack.contains('dziur') ||
        haystack.contains('ław') ||
        haystack.contains('lawk') ||
        haystack.contains('jezdn') ||
        isAlert) {
      return CityIssueKind.renovation;
    }
    return CityIssueKind.other;
  }

  bool get isCityIssue {
    return isAlert ||
        isHelp ||
        issueKind != CityIssueKind.other ||
        category.toLowerCase().contains('uwaga');
  }

  Color get issuePinColor => switch (issueKind) {
    CityIssueKind.lighting => const Color(0xFFF9A825),
    CityIssueKind.lostPet => const Color(0xFF2E7D32),
    CityIssueKind.renovation => const Color(0xFF1565C0),
    CityIssueKind.other => const Color(0xFFD32F2F),
  };

  IconData get issuePinIcon => switch (issueKind) {
    CityIssueKind.lighting => Icons.lightbulb,
    CityIssueKind.lostPet => Icons.pets,
    CityIssueKind.renovation => Icons.construction,
    CityIssueKind.other => Icons.location_on,
  };
}
