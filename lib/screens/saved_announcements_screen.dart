import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../theme/widzew_ui.dart';
import '../widgets/announcement_card.dart';
import '../widgets/empty_announcements.dart';

class SavedAnnouncementsScreen extends StatelessWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final ValueChanged<Announcement> onToggleFavorite;
  final ValueChanged<Announcement> onLikeAnnouncement;
  final void Function(Announcement announcement, String reason)
  onReportAnnouncement;
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
              hint: context.tr('savedEmptyHint'),
              icon: Icons.bookmark_border,
              fill: true,
            )
          : ListView.builder(
              key: const ValueKey('saved-list'),
              padding: const EdgeInsets.only(bottom: 80, top: 8),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              shrinkWrap: false,
              physics: const ClampingScrollPhysics(),
              itemCount: announcements.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return AnnouncementCard(
                  key: ValueKey(announcement.heroTag),
                  announcement: announcement,
                  onTap: () => onOpenAnnouncement(announcement),
                  onFavoriteToggle: () => onToggleFavorite(announcement),
                  onLike: () => onLikeAnnouncement(announcement),
                  onReact: onReact == null
                      ? null
                      : (emoji) => onReact!(announcement, emoji),
                  onReport: (reason) =>
                      onReportAnnouncement(announcement, reason),
                );
              },
            ),
    );
  }
}
