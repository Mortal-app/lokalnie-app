import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../widgets/announcement_card.dart';
import '../widgets/empty_announcements.dart';

class SavedAnnouncementsScreen extends StatelessWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final ValueChanged<Announcement> onToggleFavorite;
  final ValueChanged<Announcement> onLikeAnnouncement;
  final ValueChanged<Announcement> onReportAnnouncement;
  final void Function(Announcement announcement, String emoji)? onReact;

  const SavedAnnouncementsScreen({
    super.key,
    required this.announcements,
    required this.onOpenAnnouncement,
    required this.onToggleFavorite,
    required this.onLikeAnnouncement,
    required this.onReportAnnouncement,
    this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('savedTitle'))),
      body: announcements.isEmpty
          ? EmptyAnnouncements(
              message: context.tr('savedEmpty'),
            )
          : ListView(
              key: const ValueKey('saved-list'),
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              children: [
                for (final announcement in announcements)
                  AnnouncementCard(
                    announcement: announcement,
                    onTap: () => onOpenAnnouncement(announcement),
                    onFavoriteToggle: () => onToggleFavorite(announcement),
                    onLike: () => onLikeAnnouncement(announcement),
                    onReact: onReact == null
                        ? null
                        : (emoji) => onReact!(announcement, emoji),
                    onReport: () => onReportAnnouncement(announcement),
                  ),
              ],
            ),
    );
  }
}
