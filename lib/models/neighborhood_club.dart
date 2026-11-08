class ClubMessage {
  final String authorName;
  final String text;
  final DateTime sentAt;
  final bool isMine;

  const ClubMessage({
    required this.authorName,
    required this.text,
    required this.sentAt,
    this.isMine = false,
  });

  Map<String, Object?> toJson() => {
    'authorName': authorName,
    'text': text,
    'sentAt': sentAt.toIso8601String(),
    'isMine': isMine,
  };

  factory ClubMessage.fromJson(Map<String, dynamic> json) {
    return ClubMessage(
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      text: json['text'] as String? ?? '',
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      isMine: json['isMine'] as bool? ?? false,
    );
  }
}

class NeighborhoodClub {
  final String id;
  final String name;
  final String description;
  final String subDistrict;
  final int memberCount;
  final bool isJoined;
  final List<ClubMessage> messages;

  const NeighborhoodClub({
    required this.id,
    required this.name,
    required this.description,
    required this.subDistrict,
    this.memberCount = 12,
    this.isJoined = false,
    this.messages = const [],
  });

  NeighborhoodClub copyWith({
    int? memberCount,
    bool? isJoined,
    List<ClubMessage>? messages,
  }) {
    return NeighborhoodClub(
      id: id,
      name: name,
      description: description,
      subDistrict: subDistrict,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
      messages: messages ?? this.messages,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'subDistrict': subDistrict,
    'memberCount': memberCount,
    'isJoined': isJoined,
    'messages': messages.map((item) => item.toJson()).toList(),
  };

  factory NeighborhoodClub.fromJson(Map<String, dynamic> json) {
    return NeighborhoodClub(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      memberCount: json['memberCount'] as int? ?? 0,
      isJoined: json['isJoined'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                ClubMessage.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  static List<NeighborhoodClub> seeded() => [
    NeighborhoodClub(
      id: 'biegacze-gorkowa',
      name: 'Biegacze Górkowa',
      description: 'Poranne rozbiegania wokół Górki Widzewskiej.',
      subDistrict: 'Widzew Wschód',
      memberCount: 28,
      messages: [
        ClubMessage(
          authorName: 'Ola',
          text: 'Jutro 6:30 przy wejściu do parku — kto biegnie?',
          sentAt: DateTime(2026, 10, 22, 19, 10),
        ),
      ],
    ),
    NeighborhoodClub(
      id: 'rodzice-olechow',
      name: 'Klub Rodziców Olechów',
      description: 'Plac zabaw, babysitting na zmianę, ogłoszenia szkolne.',
      subDistrict: 'Olechów',
      memberCount: 41,
      messages: [
        ClubMessage(
          authorName: 'Kasia',
          text: 'Kto idzie na plac przy Malownicznej po 16?',
          sentAt: DateTime(2026, 10, 21, 15, 40),
        ),
      ],
    ),
    NeighborhoodClub(
      id: 'wspolnota-puszkina-10',
      name: 'Wspólnota Puszkina 10',
      description: 'Chat klatki: usterki, zrzutki, terminy administracji.',
      subDistrict: 'Widzew Wschód',
      memberCount: 19,
      messages: [
        ClubMessage(
          authorName: 'Zarząd klatki',
          text: 'W czwartek mycie klatki — prosimy nie zastawiać wycieraczek.',
          sentAt: DateTime(2026, 10, 20, 9, 0),
        ),
      ],
    ),
  ];
}
