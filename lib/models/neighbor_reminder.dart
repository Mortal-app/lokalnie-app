class NeighborReminder {
  final String id;
  final String title;
  final String body;
  final DateTime remindAt;

  const NeighborReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.remindAt,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'remindAt': remindAt.toIso8601String(),
  };

  factory NeighborReminder.fromJson(Map<String, dynamic> json) {
    return NeighborReminder(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      remindAt:
          DateTime.tryParse(json['remindAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
