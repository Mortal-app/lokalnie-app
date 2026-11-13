import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../theme/widzew_ui.dart';

class MyAnnouncementsScreen extends StatefulWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpen;
  final Future<Announcement?> Function(Announcement announcement) onEdit;
  final ValueChanged<Announcement> onComplete;
  final ValueChanged<Announcement> onDelete;

  const MyAnnouncementsScreen({
    super.key,
    required this.announcements,
    required this.onOpen,
    required this.onEdit,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  State<MyAnnouncementsScreen> createState() => _MyAnnouncementsScreenState();
}

class _MyAnnouncementsScreenState extends State<MyAnnouncementsScreen> {
  late List<Announcement> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.announcements);
  }

  void _replace(Announcement previous, Announcement next) {
    setState(() {
      _items = [
        for (final item in _items)
          if (item.publishedAt == previous.publishedAt) next else item,
      ];
    });
  }

  Future<void> _edit(Announcement announcement) async {
    final updated = await widget.onEdit(announcement);
    if (!mounted || updated == null) return;
    _replace(announcement, updated);
  }

  void _complete(Announcement announcement) {
    widget.onComplete(announcement);
    _replace(
      announcement,
      announcement.copyWith(
        status: AnnouncementStatus.resolved,
        resolvedAt: DateTime.now(),
      ),
    );
  }

  void _delete(Announcement announcement) {
    widget.onDelete(announcement);
    setState(() {
      _items = [
        for (final item in _items)
          if (item.publishedAt != announcement.publishedAt) item,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('myAnnouncements'))),
      body: _items.isEmpty
          ? Center(child: Text(context.tr('noOwnAnnouncements')))
          : ListView.builder(
              key: const ValueKey('my-announcements-list'),
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              shrinkWrap: false,
              physics: WidzewUi.listPhysics,
              itemCount: _items.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final announcement = _items[index];
                return _OwnAnnouncementTile(
                  announcement: announcement,
                  onOpen: () => widget.onOpen(announcement),
                  onEdit: () => _edit(announcement),
                  onComplete: announcement.status == AnnouncementStatus.current
                      ? () => _complete(announcement)
                      : null,
                  onDelete: () => _delete(announcement),
                );
              },
            ),
    );
  }
}

class _OwnAnnouncementTile extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback? onComplete;
  final VoidCallback onDelete;

  const _OwnAnnouncementTile({
    required this.announcement,
    required this.onOpen,
    required this.onEdit,
    required this.onComplete,
    required this.onDelete,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('confirmDeleteTitle')),
        content: Text(
          dialogContext.tr('confirmDeleteBody', {'title': announcement.title}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.tr('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.tr('delete')),
          ),
        ],
      ),
    );
    if (!context.mounted || shouldDelete != true) return;
    onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final resolved = announcement.status == AnnouncementStatus.resolved;
    final theme = Theme.of(context);
    final cardColor = resolved
        ? Color.alphaBlend(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
            theme.colorScheme.surface,
          )
        : theme.colorScheme.surface;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              isThreeLine: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(announcement.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(announcement.authorName),
                  Text(
                    announcement.price == null || announcement.price!.isEmpty
                        ? announcement.category
                        : '${announcement.category} · ${announcement.price}',
                  ),
                  Text(announcement.status.label),
                  if (resolved)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(context.tr('doneChip')),
                      ),
                    ),
                ],
              ),
              onTap: onOpen,
            ),
            Wrap(
              spacing: 4,
              children: [
                TextButton(onPressed: onEdit, child: Text(context.tr('edit'))),
                if (onComplete != null)
                  TextButton(
                    key: const ValueKey('complete-own-announcement'),
                    onPressed: onComplete,
                    child: Text(context.tr('markDone')),
                  ),
                TextButton(
                  onPressed: () => _confirmDelete(context),
                  child: Text(context.tr('delete')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
