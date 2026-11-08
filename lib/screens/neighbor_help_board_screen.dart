import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/neighbor_contact.dart';
import '../utils/relative_time.dart';
import '../utils/utf8_text_guard.dart';

class NeighborHelpBoardScreen extends StatelessWidget {
  final List<NeighborHelpPost> posts;
  final bool isProActive;
  final String clientName;
  final String tradespersonName;
  final ValueChanged<NeighborHelpPost> onAdd;
  final ValueChanged<NeighborHelpPost> onAccept;
  final VoidCallback onNeedSubscription;

  const NeighborHelpBoardScreen({
    super.key,
    required this.posts,
    required this.isProActive,
    required this.clientName,
    required this.tradespersonName,
    required this.onAdd,
    required this.onAccept,
    required this.onNeedSubscription,
  });

  List<NeighborHelpPost> _sorted(List<NeighborHelpPost> items) {
    final next = [...items];
    next.sort((a, b) {
      if (a.isUrgent == b.isUrgent) return 0;
      return a.isUrgent ? -1 : 1;
    });
    return next;
  }

  Future<void> _compose(BuildContext context) async {
    final title = TextEditingController();
    final description = TextEditingController();
    var district = Announcement.subDistricts.first;
    var urgent = false;
    var saving = false;
    final created = await showDialog<NeighborHelpPost>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Szukam fachowca'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: title,
                      decoration: const InputDecoration(
                        labelText: 'Temat (np. cieknący kran)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: description,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Opis problemu',
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: district,
                      decoration: const InputDecoration(labelText: 'Rejon'),
                      items: [
                        for (final item in Announcement.subDistricts)
                          DropdownMenuItem(value: item, child: Text(item)),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => district = value);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Awaria / Pilne'),
                      subtitle: const Text(
                        'Wyróżni na giełdzie czerwoną etykietą',
                      ),
                      value: urgent,
                      onChanged: (value) {
                        setDialogState(() => urgent = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Anuluj'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () {
                          if (Utf8TextGuard.sanitize(title.text).isEmpty ||
                              Utf8TextGuard.sanitize(description.text)
                                  .isEmpty) {
                            return;
                          }
                          setDialogState(() => saving = true);
                          Navigator.pop(
                            dialogContext,
                            NeighborHelpPost(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              title: Utf8TextGuard.sanitize(title.text),
                              description: Utf8TextGuard.sanitize(
                                description.text,
                              ),
                              subDistrict: district,
                              clientName: clientName,
                              createdAt: DateTime.now(),
                              isUrgent: urgent,
                            ),
                          );
                        },
                  child: const Text('Opublikuj'),
                ),
              ],
            );
          },
        );
      },
    );
    title.dispose();
    description.dispose();
    if (created == null || !context.mounted) return;
    onAdd(created);
  }

  void _accept(BuildContext context, NeighborHelpPost post) {
    if (!isProActive) {
      onNeedSubscription();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Przyjmowanie zleceń jest dostępne tylko z aktywnym abonamentem PRO.',
          ),
        ),
      );
      return;
    }
    onAccept(post);
    if (post.clientPhone.isNotEmpty) {
      NeighborContact.callNumber(context, post.clientPhone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Przyjęto zlecenie „${post.title}”. Skontaktuj się z ${post.clientName} w aplikacji.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Szukam Fachowca / Szukam Pomocy — krótkie zlecenia od mieszkańców Widzewa. Kontakt z klientem po przyjęciu zlecenia mają tylko fachowcy PRO.',
          ),
          const SizedBox(height: 12),
          if (posts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Brak zapytań. Dodaj pierwsze zlecenie.'),
            ),
          for (final post in _sorted(posts))
            Card(
              key: ValueKey('help-post-${post.id}'),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: WidzewUi.insets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (post.isUrgent)
                          const Chip(
                            backgroundColor: Color(0xFFFDE0E0),
                            side: BorderSide(color: Color(0xFFD32F2F)),
                            label: Text(
                              'Pilne',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${post.subDistrict} · ${post.clientName} · ${RelativeTime.format(post.createdAt)}',
                    ),
                    const SizedBox(height: 8),
                    Text(post.description),
                    const SizedBox(height: 8),
                    if (post.isOpen)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.tonalIcon(
                          onPressed: () => _accept(context, post),
                          icon: const Icon(Icons.handshake_outlined),
                          label: const Text('Odpowiedz / Przyjmij zlecenie'),
                        ),
                      )
                    else
                      Text(
                        'Przyjęte przez ${post.acceptedBy}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                  ],
                ),
              ),
            ),
        ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _compose(context),
            icon: const Icon(Icons.add),
            label: const Text('Dodaj zapytanie'),
          ),
        ),
      ],
    );
  }
}
