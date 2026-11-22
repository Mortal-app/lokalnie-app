import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/neighbor_avatar.dart';
import '../models/neighbor_conversation.dart';
import '../models/neighbor_message.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';
import '../utils/relative_time.dart';
import '../widgets/empty_announcements.dart';

class MessagesHub extends StatelessWidget {
  final List<NeighborConversation> conversations;
  final NeighborConversation? activeConversation;
  final ValueChanged<NeighborConversation> onOpenConversation;
  final VoidCallback onCloseConversation;
  final Widget Function(NeighborConversation conversation) chatBuilder;

  const MessagesHub({
    super.key,
    required this.conversations,
    required this.activeConversation,
    required this.onOpenConversation,
    required this.onCloseConversation,
    required this.chatBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeConversation;
    return Navigator(
      pages: [
        MaterialPage<void>(
          key: const ValueKey('conversations-page'),
          child: ConversationsListScreen(
            conversations: conversations,
            onOpenConversation: onOpenConversation,
          ),
        ),
        if (active != null)
          MaterialPage<void>(
            key: ValueKey('chat-${active.id}'),
            child: chatBuilder(active),
          ),
      ],
      onDidRemovePage: (page) {
        final key = page.key;
        if (key is ValueKey<String> && key.value.startsWith('chat-')) {
          onCloseConversation();
        }
      },
    );
  }
}

class ConversationsListScreen extends StatelessWidget {
  final List<NeighborConversation> conversations;
  final ValueChanged<NeighborConversation> onOpenConversation;

  const ConversationsListScreen({
    super.key,
    required this.conversations,
    required this.onOpenConversation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('messagesTitle'))),
      body: conversations.isEmpty
          ? EmptyAnnouncements(
              message: context.tr('conversationsEmpty'),
              icon: Icons.forum_outlined,
              fill: true,
            )
          : ListView.separated(
              key: const ValueKey('conversations-list'),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              shrinkWrap: false,
              physics: const ClampingScrollPhysics(),
              itemCount: conversations.length,
              addAutomaticKeepAlives: false,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  onTap: () => onOpenConversation(conversation),
                );
              },
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final NeighborConversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount;
    final preview = _previewText(context, last);
    return RepaintBoundary(
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: ListTile(
          key: ValueKey('conversation-${conversation.id}'),
          isThreeLine: conversation.listingTitle.isNotEmpty,
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: WidzewColors.redSoft,
            child: Icon(
              NeighborAvatar.at(conversation.avatarIndex),
              color: WidzewColors.red,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  conversation.peerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                last == null ? '' : _formatTime(last.sentAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: unread > 0
                      ? WidzewColors.red
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (conversation.listingTitle.isNotEmpty)
                Text(
                  conversation.listingTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: unread > 0
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: WidzewColors.red,
                      child: Text(
                        unread > 9 ? '9+' : '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _previewText(BuildContext context, NeighborMessage? message) {
    if (message == null) return '';
    if (message.isVoice) return context.tr('audioNote');
    if (message.isImage) {
      return message.text.isEmpty ? context.tr('photoMessage') : message.text;
    }
    return message.text;
  }

  String _formatTime(DateTime sentAt) {
    final now = DateTime.now();
    final local = sentAt.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    if (day == today) {
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    return RelativeTime.format(local);
  }
}
