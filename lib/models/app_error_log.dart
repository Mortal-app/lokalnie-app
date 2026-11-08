class AppErrorLog {
  final String id;
  final String at;
  final String message;

  const AppErrorLog({
    required this.id,
    required this.at,
    required this.message,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'at': at,
    'message': message,
  };

  factory AppErrorLog.fromJson(Map<String, dynamic> json) {
    return AppErrorLog(
      id: json['id'] as String? ?? '',
      at: json['at'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  static List<AppErrorLog> seeded() => const [
    AppErrorLog(
      id: 'log-ok',
      at: '28.10.2026 21:00',
      message: 'Brak błędów zapisu SharedPreferences (wpis demo).',
    ),
  ];
}
