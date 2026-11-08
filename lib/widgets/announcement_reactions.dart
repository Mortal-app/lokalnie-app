import 'package:flutter/material.dart';

import '../models/announcement.dart';

class AnnouncementReactionsBar extends StatelessWidget {
  final Announcement announcement;
  final ValueChanged<String> onReact;
  final bool compact;

  const AnnouncementReactionsBar({
    super.key,
    required this.announcement,
    required this.onReact,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: compact ? 2 : 6,
      children: [
        for (final emoji in Announcement.reactionEmojis)
          ActionChip(
            key: ValueKey('reaction-$emoji-${announcement.heroTag}'),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8),
            backgroundColor: announcement.myReaction == emoji
                ? theme.colorScheme.primary.withValues(alpha: 0.16)
                : null,
            label: Text(
              '$emoji ${announcement.reactions[emoji] ?? 0}',
              style: TextStyle(fontSize: compact ? 11 : 13),
            ),
            onPressed: () => onReact(emoji),
          ),
      ],
    );
  }
}
