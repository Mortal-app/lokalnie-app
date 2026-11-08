enum NeighborMessageStatus { sent, read }

extension NeighborMessageStatusLabel on NeighborMessageStatus {
  String get label => switch (this) {
    NeighborMessageStatus.sent => 'Wysłano',
    NeighborMessageStatus.read => 'Przeczytano',
  };
}

class NeighborMessage {
  final String id;
  final String text;
  final bool isMine;
  final NeighborMessageStatus status;
  final DateTime sentAt;
  final bool isVoice;
  final int durationSeconds;
  final String? imagePath;
  final String? audioPath;
  final String conversationId;
  final String peerName;
  final String listingTitle;
  final int avatarIndex;

  const NeighborMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.status,
    required this.sentAt,
    this.isVoice = false,
    this.durationSeconds = 0,
    this.imagePath,
    this.audioPath,
    this.conversationId = 'legacy',
    this.peerName = 'Sąsiad',
    this.listingTitle = '',
    this.avatarIndex = 0,
  });

  bool get isImage {
    final path = imagePath;
    return path != null && path.isNotEmpty;
  }

  NeighborMessage copyWith({NeighborMessageStatus? status}) {
    return NeighborMessage(
      id: id,
      text: text,
      isMine: isMine,
      status: status ?? this.status,
      sentAt: sentAt,
      isVoice: isVoice,
      durationSeconds: durationSeconds,
      imagePath: imagePath,
      audioPath: audioPath,
      conversationId: conversationId,
      peerName: peerName,
      listingTitle: listingTitle,
      avatarIndex: avatarIndex,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'text': text,
    'isMine': isMine,
    'status': status.name,
    'sentAt': sentAt.toIso8601String(),
    'isVoice': isVoice,
    'durationSeconds': durationSeconds,
    'imagePath': imagePath,
    'audioPath': audioPath,
    'conversationId': conversationId,
    'peerName': peerName,
    'listingTitle': listingTitle,
    'avatarIndex': avatarIndex,
  };

  factory NeighborMessage.fromJson(Map<String, dynamic> json) {
    return NeighborMessage(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isMine: json['isMine'] as bool? ?? true,
      status: json['status'] == NeighborMessageStatus.read.name
          ? NeighborMessageStatus.read
          : NeighborMessageStatus.sent,
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      isVoice: json['isVoice'] as bool? ?? false,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      imagePath: json['imagePath'] as String?,
      audioPath: json['audioPath'] as String?,
      conversationId: json['conversationId'] as String? ?? 'legacy',
      peerName: json['peerName'] as String? ?? 'Sąsiad',
      listingTitle: json['listingTitle'] as String? ?? '',
      avatarIndex: json['avatarIndex'] as int? ?? 0,
    );
  }

  static const washerConversationId = 'janow-pralka';
  static const wildlifeConversationId = 'olechow-dziki';
  static const keysConversationId = 'stary-klucze';

  static List<NeighborMessage> seeded() => [
    NeighborMessage(
      id: 'welcome',
      conversationId: washerConversationId,
      peerName: 'Sąsiad z Janowa',
      listingTitle: 'Oddam sprawną pralkę za darmo (odbiór Janów)',
      avatarIndex: 1,
      text:
          'Cześć sąsiedzie! Daj znać, jeśli ogłoszenie z pralką jest aktualne.',
      isMine: false,
      status: NeighborMessageStatus.read,
      sentAt: DateTime(2026, 10, 22, 10, 15),
    ),
    NeighborMessage(
      id: 'wildlife-1',
      conversationId: wildlifeConversationId,
      peerName: 'Sąsiadka z Olechowa',
      listingTitle: 'Uwaga! Dziki przy ul. Puszkarskiej / w pobliżu parku',
      avatarIndex: 16,
      text: 'Widziałaś je też przy blokach? Trzymaj psa na smyczy.',
      isMine: false,
      status: NeighborMessageStatus.sent,
      sentAt: DateTime(2026, 10, 22, 18, 40),
    ),
    NeighborMessage(
      id: 'keys-1',
      conversationId: keysConversationId,
      peerName: 'Sąsiad ze Starego Widzewa',
      listingTitle: 'Znaleziono klucze w parku Górka Widzewska',
      avatarIndex: 58,
      text: 'Opiszę brelok: czerwony rower.',
      isMine: true,
      status: NeighborMessageStatus.read,
      sentAt: DateTime(2026, 10, 21, 16, 5),
    ),
  ];
}
