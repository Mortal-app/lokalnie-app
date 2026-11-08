import 'neighbor_message.dart';

class NeighborConversation {
  final String id;
  final String peerName;
  final String listingTitle;
  final int avatarIndex;
  final List<NeighborMessage> messages;

  const NeighborConversation({
    required this.id,
    required this.peerName,
    required this.listingTitle,
    required this.avatarIndex,
    required this.messages,
  });

  NeighborMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  DateTime get lastSentAt =>
      lastMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  int get unreadCount => messages
      .where(
        (message) =>
            !message.isMine && message.status == NeighborMessageStatus.sent,
      )
      .length;

  static List<NeighborConversation> group(List<NeighborMessage> messages) {
    if (messages.isEmpty) return const [];
    final grouped = <String, List<NeighborMessage>>{};
    for (final message in messages) {
      grouped.putIfAbsent(message.conversationId, () => []).add(message);
    }
    final conversations = grouped.entries.map((entry) {
      final items = [...entry.value]
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
      final latest = items.last;
      return NeighborConversation(
        id: entry.key,
        peerName: latest.peerName.isNotEmpty
            ? latest.peerName
            : items.first.peerName,
        listingTitle: latest.listingTitle.isNotEmpty
            ? latest.listingTitle
            : items.first.listingTitle,
        avatarIndex: latest.avatarIndex,
        messages: items,
      );
    }).toList()..sort((a, b) => b.lastSentAt.compareTo(a.lastSentAt));
    return conversations;
  }
}
