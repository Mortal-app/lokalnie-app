class PollOption {
  final String label;
  final int votes;

  const PollOption({required this.label, this.votes = 0});

  PollOption copyWith({int? votes}) =>
      PollOption(label: label, votes: votes ?? this.votes);

  Map<String, Object?> toJson() => {'label': label, 'votes': votes};

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      label: json['label'] as String? ?? '',
      votes: json['votes'] as int? ?? 0,
    );
  }
}

class NeighborhoodPoll {
  final String id;
  final String question;
  final List<PollOption> options;
  final int? selectedOptionIndex;

  const NeighborhoodPoll({
    required this.id,
    required this.question,
    required this.options,
    this.selectedOptionIndex,
  });

  int get totalVotes =>
      options.fold<int>(0, (sum, option) => sum + option.votes);

  bool get hasVoted => selectedOptionIndex != null;

  double percentFor(int index) {
    final total = totalVotes;
    if (total == 0) return 0;
    return options[index].votes / total;
  }

  NeighborhoodPoll vote(int optionIndex) {
    if (hasVoted || optionIndex < 0 || optionIndex >= options.length) {
      return this;
    }
    final updated = [...options];
    updated[optionIndex] = updated[optionIndex].copyWith(
      votes: updated[optionIndex].votes + 1,
    );
    return NeighborhoodPoll(
      id: id,
      question: question,
      options: updated,
      selectedOptionIndex: optionIndex,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'question': question,
    'options': options.map((option) => option.toJson()).toList(),
    'selectedOptionIndex': selectedOptionIndex,
  };

  factory NeighborhoodPoll.fromJson(Map<String, dynamic> json) {
    return NeighborhoodPoll(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>? ?? const [])
          .map(
            (item) => PollOption.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      selectedOptionIndex: json['selectedOptionIndex'] as int?,
    );
  }

  static List<NeighborhoodPoll> seeded() => const [
    NeighborhoodPoll(
      id: 'playground',
      question: 'Czy chcemy nowy plac zabaw?',
      options: [
        PollOption(label: 'Tak', votes: 12),
        PollOption(label: 'Nie', votes: 4),
        PollOption(label: 'Wstrzymuję się', votes: 2),
      ],
    ),
    NeighborhoodPoll(
      id: 'square-name',
      question: 'Wybór nazwy dla skweru',
      options: [
        PollOption(label: 'Skwer osiedlowy', votes: 9),
        PollOption(label: 'Skwer łąkowy', votes: 7),
        PollOption(label: 'Skwer parkowy', votes: 5),
      ],
    ),
  ];
}
