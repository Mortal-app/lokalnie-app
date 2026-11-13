class CommunityStats {
  final int rescuedItems;
  final int activeNeighborsThisWeek;
  final int resolvedReports;
  final int neighborsOnBoard;

  const CommunityStats({
    required this.rescuedItems,
    required this.activeNeighborsThisWeek,
    required this.resolvedReports,
    required this.neighborsOnBoard,
  });

  @override
  bool operator ==(Object other) {
    return other is CommunityStats &&
        other.rescuedItems == rescuedItems &&
        other.activeNeighborsThisWeek == activeNeighborsThisWeek &&
        other.resolvedReports == resolvedReports &&
        other.neighborsOnBoard == neighborsOnBoard;
  }

  @override
  int get hashCode => Object.hash(
    rescuedItems,
    activeNeighborsThisWeek,
    resolvedReports,
    neighborsOnBoard,
  );
}
