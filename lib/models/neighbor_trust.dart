class NeighborTrust {
  final int monthsActive;
  final int completedHelps;

  const NeighborTrust({
    required this.monthsActive,
    required this.completedHelps,
  });

  factory NeighborTrust.forAuthor(String authorName, {int likesCount = 0}) {
    final seed = authorName.hashCode.abs();
    return NeighborTrust(
      monthsActive: 2 + seed % 22,
      completedHelps: likesCount + seed % 11,
    );
  }

  String get membershipLabel => monthsActive == 1
      ? 'Sąsiad od 1 miesiąca'
      : 'Sąsiad od $monthsActive miesięcy';

  String get helpsLabel => completedHelps == 1
      ? '1 udana pomoc'
      : '$completedHelps udanych pomocy';

  String get summary => '$membershipLabel · $helpsLabel';

  bool get isVerified => monthsActive >= 3 || completedHelps >= 3;
}
