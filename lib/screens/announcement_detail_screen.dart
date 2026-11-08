import 'dart:async';

import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/borrow_terms.dart';
import '../models/neighbor_trust.dart';
import '../screens/report_announcement.dart';
import '../utils/lending_reservation.dart';
import '../utils/neighbor_contact.dart';
import '../utils/neighbor_share.dart';
import '../theme/widzew_ui.dart';
import '../utils/relative_time.dart';
import '../widgets/announcement_contact_links.dart';
import '../widgets/announcement_photo.dart';
import '../widgets/announcement_reactions.dart';
import '../widgets/app_page_route.dart';
import '../widgets/verified_neighbor_badge.dart';
import 'photo_gallery_screen.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;
  final ValueChanged<Announcement> onToggleFavorite;
  final ValueChanged<String> onAddComment;
  final ValueChanged<AnnouncementStatus> onStatusChanged;
  final String currentUserName;
  final VoidCallback? onReport;
  final VoidCallback? onRemindTomorrow;
  final ValueChanged<String>? onReact;
  final VoidCallback? onWriteToAuthor;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
    required this.onToggleFavorite,
    required this.onAddComment,
    required this.onStatusChanged,
    this.currentUserName = 'Sąsiad',
    this.onReport,
    this.onRemindTomorrow,
    this.onReact,
    this.onWriteToAuthor,
  });

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  late bool _isFavorite;
  late AnnouncementStatus _status;
  late List<AnnouncementComment> _comments;
  late Announcement _item;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _item = widget.announcement;
    _isFavorite = widget.announcement.isFavorite;
    _status = widget.announcement.status;
    _comments = List.of(widget.announcement.comments);
  }

  void _react(String emoji) {
    setState(() => _item = _item.withReaction(emoji));
    widget.onReact?.call(emoji);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  static const _quickQuestions = [
    'Czy aktualne?',
    'Gdzie dokładnie odbiór?',
    'Jaka cena / warunki?',
  ];

  NeighborTrust get _trust => NeighborTrust.forAuthor(
    widget.announcement.authorName,
    likesCount: widget.announcement.likesCount,
  );

  Future<void> _shareAnnouncement() {
    return NeighborShare.share(
      context,
      widget.announcement,
      copiedMessage: 'Skopiowano link do ogłoszenia',
    );
  }

  void _submitComment([String? preset]) {
    final comment = (preset ?? _commentController.text).trim();
    if (comment.isEmpty) return;
    setState(() {
      _comments = [
        ..._comments,
        AnnouncementComment(authorName: widget.currentUserName, text: comment),
      ];
      _commentController.clear();
    });
    widget.onAddComment(comment);
  }

  void _markResolved() {
    setState(() => _status = AnnouncementStatus.resolved);
    widget.onStatusChanged(AnnouncementStatus.resolved);
    if (!widget.announcement.isHelp || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Zrealizowane – Dziękuję sąsiedzie!'),
        ),
      );
  }

  String _formatDateTime(DateTime dateTime) => RelativeTime.format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły ogłoszenia'),
        actions: [
          IconButton(
            tooltip: 'Udostępnij ogłoszenie',
            onPressed: _shareAnnouncement,
            icon: const Icon(Icons.share_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'Więcej opcji',
            onSelected: (value) async {
              if (value != 'report') return;
              final reason = await showAnnouncementReportDialog(context);
              if (reason == null || !context.mounted) return;
              showReportAcceptedMessage(context, reason);
              widget.onReport?.call();
              if (context.mounted) Navigator.of(context).pop();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'report',
                child: Text('Zgłoś ogłoszenie'),
              ),
            ],
          ),
          IconButton(
            tooltip: _isFavorite ? 'Usuń z ulubionych' : 'Dodaj do ulubionych',
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              widget.onToggleFavorite(widget.announcement);
            },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? const Color(0xFFD32F2F) : null,
            ),
          ),
        ],
      ),
      body: ListView(
        key: const ValueKey('announcement-detail-list'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          Hero(
            tag: '${widget.announcement.heroTag}-title',
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                widget.announcement.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Hero(
                tag: widget.announcement.heroTag,
                child: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  child: Icon(
                    widget.announcement.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerifiedNeighborBadge(
                      authorName: widget.announcement.authorName,
                      likesCount: widget.announcement.likesCount,
                      nameStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _trust.summary,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.announcement.hasImage) ...[
            const SizedBox(height: 16),
            Hero(
              tag: '${widget.announcement.heroTag}-photo',
              child: ClipRRect(
                borderRadius: WidzewUi.borderRadius,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnnouncementPhoto(announcement: widget.announcement),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            AppPageRoute<void>(
                              builder: (_) => PhotoGalleryScreen(
                                announcement: widget.announcement,
                              ),
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Chip(
                                avatar: Icon(Icons.zoom_in, size: 18),
                                label: Text('Galeria'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(
                avatar: Icon(widget.announcement.icon, size: 18),
                label: Text(widget.announcement.category),
              ),
              const Icon(Icons.schedule, size: 18),
              Text(_formatDateTime(widget.announcement.publishedAt)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(widget.announcement.subDistrict),
                ],
              ),
              Chip(
                avatar: Icon(
                  _status == AnnouncementStatus.current
                      ? Icons.check_circle_outline
                      : Icons.task_alt,
                  size: 18,
                ),
                label: Text(_status.label),
              ),
              ActionChip(
                avatar: const Icon(Icons.share_outlined, size: 18),
                label: const Text('Udostępnij'),
                onPressed: _shareAnnouncement,
              ),
              if (widget.onRemindTomorrow != null)
                ActionChip(
                  avatar: const Icon(Icons.alarm_add_outlined, size: 18),
                  label: const Text('Przypomnij mi jutro'),
                  onPressed: widget.onRemindTomorrow,
                ),
              if (widget.announcement.borrowTerms != null)
                Chip(
                  avatar: const Icon(Icons.handshake_outlined, size: 18),
                  label: Text(widget.announcement.borrowTerms!.label),
                ),
            ],
          ),
          if (widget.announcement.isLending) ...[
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => LendingReservation.requestDate(context),
              icon: const Icon(Icons.event_available_outlined),
              label: const Text('Poproś o rezerwację terminu'),
            ),
          ],
          const SizedBox(height: 12),
          AnnouncementReactionsBar(
            announcement: _item,
            onReact: _react,
          ),
          const SizedBox(height: 24),
          Text('Opis', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            widget.announcement.description.isEmpty
                ? 'Brak dodatkowego opisu.'
                : widget.announcement.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (_status == AnnouncementStatus.current &&
              (widget.announcement.isMine || widget.announcement.isHelp)) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _markResolved,
              icon: const Icon(Icons.task_alt),
              label: Text(
                widget.announcement.isHelp
                    ? 'Zrealizowane – Dziękuję sąsiedzie!'
                    : 'Oznacz jako rozwiązane',
              ),
            ),
          ],
          const SizedBox(height: 20),
          Card(
            key: const ValueKey('announcement-stats'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statystyki ogłoszenia',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.visibility_outlined, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${widget.announcement.viewsCount} wyświetleń',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => NeighborContact.reportOutdated(context),
                      icon: const Icon(Icons.event_busy_outlined),
                      label: const Text('Zgłoś nieaktualne'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            key: const ValueKey('neighbor-questions-header'),
            'Pytania i komentarze sąsiedzkie',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final question in _quickQuestions)
                ActionChip(
                  key: ValueKey('quick-question-$question'),
                  label: Text(question),
                  onPressed: () => _submitComment(question),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_comments.isEmpty)
            Text(
              'Brak komentarzy. Rozpocznij rozmowę z sąsiadami.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          for (final comment in _comments)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(comment.authorName),
              subtitle: Text(comment.text),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('announcement-comment'),
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Dodaj komentarz',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                key: const ValueKey('send-comment'),
                tooltip: 'Wyślij komentarz',
                onPressed: () => _submitComment(),
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kontakt z autorem',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => NeighborContact.callOrSms(context),
                        icon: const Icon(Icons.phone_outlined),
                        label: const Text('Zadzwoń / SMS'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => unawaited(
                          NeighborContact.sendSms(
                            context,
                            widget.announcement,
                          ),
                        ),
                        icon: const Icon(Icons.sms_outlined),
                        label: const Text('Wyślij SMS'),
                      ),
                      FilledButton.icon(
                        onPressed: () => unawaited(
                          NeighborContact.sendWhatsApp(
                            context,
                            widget.announcement,
                          ),
                        ),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('Napisz na WhatsApp'),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          NeighborContact.sendMessage(context);
                          widget.onWriteToAuthor?.call();
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Napisz do sąsiada'),
                      ),
                      AnnouncementContactLinks(
                        announcement: widget.announcement,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
