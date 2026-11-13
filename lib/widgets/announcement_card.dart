import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/borrow_terms.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';
import '../screens/photo_gallery_screen.dart';
import '../screens/report_announcement.dart';
import '../utils/relative_time.dart';
import 'app_page_route.dart';
import 'announcement_photo.dart';
import 'announcement_reactions.dart';
import 'verified_neighbor_badge.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onLike;
  final ValueChanged<String>? onReport;
  final ValueChanged<String>? onReact;
  final bool useHero;
  final bool compact;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onLike,
    this.onReport,
    this.onReact,
    this.useHero = true,
    this.compact = false,
  });

  bool get _isAlert {
    final category = announcement.category.toLowerCase();
    return category == Announcement.wildlifeCategory.toLowerCase() ||
        category.contains('uwaga') ||
        category.contains('ostrze');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final alertColor = isDark
        ? const Color(0xFF4E342E)
        : const Color(0xFFFFF3E0);

    final resolved = announcement.status == AnnouncementStatus.resolved;
    final accent = announcement.accentLabel;
    final outline = _isAlert
        ? const Color(0xFFEF6C00)
        : isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.5)
        : const Color(0xFFD0D0D0);

    final surface = theme.colorScheme.surface;
    final cardColor = resolved
        ? Color.alphaBlend(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
            surface,
          )
        : _isAlert
        ? alertColor
        : surface;

    return RepaintBoundary(
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: compact ? 8 : WidzewUi.padWide,
          vertical: compact ? 6 : 10,
        ),
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: WidzewUi.borderRadius,
          side: BorderSide(color: outline, width: _isAlert ? 1.4 : 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (announcement.hasImage)
                _maybeHero(
                  tag: '${announcement.heroTag}-photo',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => _openPhotoLightbox(context),
                      child: SizedBox(
                        height: compact ? 88 : 140,
                        child: AnnouncementPhoto(
                          announcement: announcement,
                          memCacheWidth: compact
                              ? MediaQuery.sizeOf(context).width / 2
                              : MediaQuery.sizeOf(context).width,
                          memCacheHeight: compact ? 88 : 140,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _maybeHero(
                      tag: announcement.heroTag,
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: Icon(
                          announcement.icon,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _maybeHero(
                            tag: '${announcement.heroTag}-title',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                announcement.title,
                                softWrap: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (announcement.pendingSync)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isDark
                                      ? const Color(0xFF4E342E)
                                      : const Color(0xFFFFE0B2),
                                  label: Text(
                                    'Czeka na sieć',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: isDark
                                          ? WidzewColors.inkOnDark
                                          : const Color(0xFF5D4037),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (announcement.contentFlagged)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isDark
                                      ? const Color(0xFF4E342E)
                                      : const Color(0xFFFFE0B2),
                                  label: Text(
                                    'Do sprawdzenia',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFFFE0B2)
                                          : const Color(0xFFE65100),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (announcement.isFree)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isDark
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFFC8E6C9),
                                  label: Text(
                                    'ZA DARMO',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFC8E6C9)
                                          : const Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (announcement.isLending &&
                                  announcement.borrowTerms != null)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    announcement.borrowTerms!.label,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              if (accent != null)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isDark
                                      ? announcement.accentColor.withValues(
                                          alpha: 0.28,
                                        )
                                      : announcement.accentFill,
                                  side: BorderSide(
                                    color: announcement.accentColor,
                                  ),
                                  label: Text(
                                    accent,
                                    style: TextStyle(
                                      color: isDark
                                          ? theme.colorScheme.onSurface
                                          : announcement.accentColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (resolved)
                                const Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    'Załatwione',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              Chip(
                                visualDensity: VisualDensity.compact,
                                label: Text(
                                  announcement.category,
                                  softWrap: true,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          VerifiedNeighborBadge(
                            authorName: announcement.authorName,
                            likesCount: announcement.likesCount,
                            compact: true,
                            nameStyle: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 10,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    announcement.subDistrict,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                              Text(
                                RelativeTime.format(announcement.publishedAt),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: announcement.isLiked
                          ? 'Polubiono'
                          : 'Polub ogłoszenie',
                      onPressed: announcement.isLiked ? null : onLike,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 32,
                      ),
                      icon: Icon(
                        announcement.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: announcement.isLiked
                            ? theme.colorScheme.primary
                            : null,
                        size: 20,
                      ),
                    ),
                    Text(
                      '${announcement.likesCount}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: announcement.isFavorite
                          ? 'Usuń z ulubionych'
                          : 'Dodaj do ulubionych',
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        announcement.isFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: announcement.isFavorite
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    if (onReport != null && !announcement.isMine)
                      IconButton(
                        tooltip: 'Zgłoś nadużycie',
                        onPressed: () => _handleMenu(context, 'report'),
                        icon: const Icon(Icons.flag_outlined, size: 20),
                      ),
                    if (onReport != null && !announcement.isMine)
                      PopupMenuButton<String>(
                        tooltip: 'Więcej opcji',
                        onSelected: (value) => _handleMenu(context, value),
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'report',
                            child: Text('Zgłoś nadużycie'),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert, size: 20),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: AnnouncementReactionsBar(
                  announcement: announcement,
                  onReact: onReact ?? (_) {},
                  compact: compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _maybeHero({required String tag, required Widget child}) {
    if (!useHero) return child;
    return Hero(tag: tag, child: child);
  }

  Future<void> _handleMenu(BuildContext context, String value) async {
    if (value != 'report') return;
    final reason = await showAnnouncementReportDialog(context);
    if (reason == null || !context.mounted) return;
    onReport?.call(reason);
  }

  void _openPhotoLightbox(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PhotoGalleryScreen(announcement: announcement),
      ),
    );
  }
}
