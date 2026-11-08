enum CostSplitKind { transport, materials, party }

extension CostSplitKindX on CostSplitKind {
  String get label => switch (this) {
    CostSplitKind.transport => 'Transport',
    CostSplitKind.materials => 'Materiały budowlane',
    CostSplitKind.party => 'Impreza osiedlowa',
  };
}

class CostSplit {
  final String id;
  final String title;
  final CostSplitKind kind;
  final double total;
  final int people;
  final String note;

  const CostSplit({
    required this.id,
    required this.title,
    required this.kind,
    required this.total,
    required this.people,
    this.note = '',
  });

  double get share => people <= 0 ? 0 : total / people;

  String get summary {
    final notePart = note.isEmpty ? '' : ' ($note)';
    return 'Podsumowanie: ${title.isEmpty ? kind.label : title}$notePart — '
        '${total.toStringAsFixed(2)} zł / $people os. = '
        '${share.toStringAsFixed(2)} zł na osobę.';
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'kind': kind.name,
    'total': total,
    'people': people,
    'note': note,
  };

  factory CostSplit.fromJson(Map<String, dynamic> json) {
    return CostSplit(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      kind: CostSplitKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CostSplitKind.party,
      ),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      people: json['people'] as int? ?? 2,
      note: json['note'] as String? ?? '',
    );
  }

  static List<CostSplit> seeded() => const [
    CostSplit(
      id: 'split-castorama',
      title: 'Wyjazd po płyty OSB',
      kind: CostSplitKind.materials,
      total: 480,
      people: 4,
      note: 'Castorama + benzyna',
    ),
    CostSplit(
      id: 'split-grill',
      title: 'Grill klatki I',
      kind: CostSplitKind.party,
      total: 220,
      people: 8,
      note: 'kiełbasa i napoje',
    ),
  ];
}
