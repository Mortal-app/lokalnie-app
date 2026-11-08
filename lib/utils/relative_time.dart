class RelativeTime {
  static String format(DateTime dateTime, {DateTime? now}) {
    final local = dateTime.toLocal();
    final current = (now ?? DateTime.now()).toLocal();
    final diff = current.difference(local);
    if (!diff.isNegative) {
      if (diff.inSeconds < 60) return 'Przed chwilą';
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} ${_unit(diff.inMinutes, _Unit.minute)} temu';
      }
      if (diff.inHours < 24) {
        return '${diff.inHours} ${_unit(diff.inHours, _Unit.hour)} temu';
      }
    }

    final today = DateTime(current.year, current.month, current.day);
    final day = DateTime(local.year, local.month, local.day);
    if (day == today) return 'Dzisiaj';
    if (day == today.subtract(const Duration(days: 1))) return 'Wczoraj';
    if (!diff.isNegative && diff.inDays < 7) {
      return '${diff.inDays} ${_unit(diff.inDays, _Unit.day)} temu';
    }
    return '${_two(local.day)}.${_two(local.month)}.${local.year}';
  }

  static String _unit(int count, _Unit unit) {
    final abs = count.abs();
    final mod10 = abs % 10;
    final mod100 = abs % 100;
    final form = abs == 1
        ? 0
        : (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14) ? 1 : 2);
    return switch (unit) {
      _Unit.minute => ['minutę', 'minuty', 'minut'][form],
      _Unit.hour => ['godzinę', 'godziny', 'godzin'][form],
      _Unit.day => ['dzień', 'dni', 'dni'][form],
    };
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}

enum _Unit { minute, hour, day }
