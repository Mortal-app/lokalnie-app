import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PublishGate {
  final bool allowed;
  final String message;

  const PublishGate.ok() : allowed = true, message = '';
  const PublishGate.blocked(this.message) : allowed = false;
}

class FilterDecision {
  final bool blocked;
  final bool flagged;
  final String message;

  const FilterDecision.clean() : blocked = false, flagged = false, message = '';

  const FilterDecision.block(this.message) : blocked = true, flagged = false;

  const FilterDecision.flag(this.message) : blocked = false, flagged = true;
}

class ContentReport {
  final String reporterId;
  final String reason;
  final DateTime at;

  const ContentReport({
    required this.reporterId,
    required this.reason,
    required this.at,
  });

  Map<String, Object?> toJson() => {
    'reporterId': reporterId,
    'reason': reason,
    'at': at.toIso8601String(),
  };

  factory ContentReport.fromJson(Map<String, dynamic> json) {
    return ContentReport(
      reporterId: json['reporterId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class ReportOutcome {
  final bool accepted;
  final bool hidden;
  final int count;
  final String message;

  const ReportOutcome({
    required this.accepted,
    required this.hidden,
    required this.count,
    required this.message,
  });
}

class BoardSafety {
  static const maxPostsPerDay = 3;
  static const cooldown = Duration(seconds: 60);
  static const hideAfterReports = 3;

  static const reportReasons = [
    'Spam / Reklama',
    'Treść obraźliwa',
    'Oszustwo',
  ];

  static PublishGate publishGate(
    List<DateTime> times, {
    DateTime? now,
    bool bypass = false,
  }) {
    if (bypass) return const PublishGate.ok();
    final clock = now ?? DateTime.now();
    final dayAgo = clock.subtract(const Duration(hours: 24));
    final recent = times.where((time) => !time.isBefore(dayAgo)).toList()
      ..sort();
    if (recent.length >= maxPostsPerDay) {
      return const PublishGate.blocked(
        'Limit 3 ogłoszeń na dobę. Spróbuj ponownie jutro.',
      );
    }
    if (recent.isNotEmpty) {
      final wait = cooldown - clock.difference(recent.last);
      if (wait > Duration.zero) {
        final seconds = wait.inSeconds + 1;
        return PublishGate.blocked(
          'Poczekaj $seconds s przed kolejną publikacją.',
        );
      }
    }
    return const PublishGate.ok();
  }

  static ReportOutcome recordReport({
    required Map<String, List<ContentReport>> reports,
    required String announcementKey,
    required String reporterId,
    required String reason,
    DateTime? now,
  }) {
    final existing = List<ContentReport>.from(reports[announcementKey] ?? []);
    final reporter = reporterId.trim();
    if (reporter.isNotEmpty &&
        existing.any((item) => item.reporterId == reporter)) {
      return ReportOutcome(
        accepted: false,
        hidden: existing.length >= hideAfterReports,
        count: existing.length,
        message: 'To ogłoszenie już zgłosiłeś.',
      );
    }
    existing.add(
      ContentReport(
        reporterId: reporter.isEmpty ? 'sąsiad' : reporter,
        reason: reason,
        at: now ?? DateTime.now(),
      ),
    );
    reports[announcementKey] = existing;
    final hidden = existing.length >= hideAfterReports;
    return ReportOutcome(
      accepted: true,
      hidden: hidden,
      count: existing.length,
      message: hidden
          ? 'Ogłoszenie ukryte z tablicy i przekazane do weryfikacji.'
          : 'Dziękujemy. Zgłoszenie ($reason) przyjęte (${existing.length}/$hideAfterReports).',
    );
  }
}

class ContentFilter {
  static final _profanity = RegExp(
    r'\b(kurw\w*|kurew\w*|chuj\w*|jeb\w*|pierdol\w*|spierdal\w*|kutas\w*|cip\w*|zjeb\w*|suka\b|sukinsyn\w*|peda[lł]\w*|cwel\w*)\b',
    caseSensitive: false,
  );

  static final _spam = RegExp(
    r'(viagra|cialis|crypto|bitcoin|forex|kasyno|casino|pożyczk\w*\s+bez\s+bik|darmowe pieniądze|kliknij tutaj|click here|telegram\.me|t\.me/|bit\.ly|tinyurl|okazja!!!|100%\s*gwarancja)',
    caseSensitive: false,
  );

  static final _url = RegExp(
    r'(https?:\/\/|www\.)[^\s]+|\b[a-z0-9-]+\.(com|net|org|ru|xyz|click|top|info|biz|shop|loan)\b',
    caseSensitive: false,
  );

  static final _allowedHost = RegExp(
    r'(lodz\.pl|uml\.lodz|widzew|gov\.pl|edu\.pl)',
    caseSensitive: false,
  );

  static FilterDecision inspect(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return const FilterDecision.clean();
    if (_profanity.hasMatch(text)) {
      return const FilterDecision.block(
        'Treść zawiera niedozwolone sformułowania. Usuń wulgaryzmy i spróbuj ponownie.',
      );
    }
    if (_spam.hasMatch(text)) {
      return const FilterDecision.block(
        'Wykryto treść reklamową / spamową. Taka publikacja jest zablokowana.',
      );
    }
    final urls = _url.allMatches(text).map((match) => match.group(0) ?? '');
    for (final url in urls) {
      if (url.isEmpty) continue;
      if (_allowedHost.hasMatch(url)) continue;
      return const FilterDecision.flag(
        'Opublikowano z flagą ostrzegawczą: wykryto zewnętrzny link.',
      );
    }
    return const FilterDecision.clean();
  }
}

class BoardSafetyStore {
  static const prefsKey = 'board_safety_v1';

  static var _loaded = false;
  static final List<DateTime> publishTimes = [];
  static final Map<String, List<ContentReport>> reports = {};
  static final Set<String> reviewKeys = {};
  static final Set<String> flaggedKeys = {};

  static Future<void> load() async {
    if (_loaded) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final json = jsonDecode(raw);
        if (json is Map) {
          final map = Map<String, dynamic>.from(json);
          publishTimes
            ..clear()
            ..addAll(
              (map['publishes'] as List<dynamic>? ?? const []).map(
                (item) =>
                    DateTime.tryParse('$item') ??
                    DateTime.fromMillisecondsSinceEpoch(0),
              ),
            );
          reports
            ..clear()
            ..addAll({
              for (final entry
                  in (map['reports'] is Map
                          ? Map<String, dynamic>.from(map['reports'] as Map)
                          : const <String, dynamic>{})
                      .entries)
                entry.key: (entry.value as List<dynamic>? ?? const [])
                    .map(
                      (item) => ContentReport.fromJson(
                        Map<String, dynamic>.from(item as Map),
                      ),
                    )
                    .toList(),
            });
          reviewKeys
            ..clear()
            ..addAll(
              (map['review'] as List<dynamic>? ?? const []).map(
                (item) => '$item',
              ),
            );
          flaggedKeys
            ..clear()
            ..addAll(
              (map['flagged'] as List<dynamic>? ?? const []).map(
                (item) => '$item',
              ),
            );
        }
      }
    } catch (_) {}
    _loaded = true;
  }

  static Future<void> recordPublish(DateTime at) async {
    await load();
    publishTimes.add(at);
    await _save();
  }

  static ReportOutcome addReport({
    required String announcementKey,
    required String reporterId,
    required String reason,
  }) {
    final outcome = BoardSafety.recordReport(
      reports: reports,
      announcementKey: announcementKey,
      reporterId: reporterId,
      reason: reason,
    );
    if (outcome.accepted && outcome.hidden) {
      reviewKeys.add(announcementKey);
    }
    unawaited(_save());
    return outcome;
  }

  static int reportCount(String announcementKey) =>
      reports[announcementKey]?.length ?? 0;

  static Future<void> restore(String announcementKey) async {
    await load();
    reviewKeys.remove(announcementKey);
    await _save();
  }

  static Future<void> dismissReview(String announcementKey) async {
    await load();
    reviewKeys.remove(announcementKey);
    await _save();
  }

  static Future<void> markFlagged(String announcementKey) async {
    await load();
    flaggedKeys.add(announcementKey);
    await _save();
  }

  static Future<void> clear() async {
    publishTimes.clear();
    reports.clear();
    reviewKeys.clear();
    flaggedKeys.clear();
    _loaded = true;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(prefsKey);
    } catch (_) {}
  }

  static Future<void> _save() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        prefsKey,
        jsonEncode({
          'publishes': publishTimes
              .map((item) => item.toIso8601String())
              .toList(),
          'reports': {
            for (final entry in reports.entries)
              entry.key: entry.value.map((item) => item.toJson()).toList(),
          },
          'review': reviewKeys.toList(),
          'flagged': flaggedKeys.toList(),
        }),
      );
    } catch (_) {}
  }
}
