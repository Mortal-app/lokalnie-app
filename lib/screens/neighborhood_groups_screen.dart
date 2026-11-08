import 'package:flutter/material.dart';

import '../models/neighborhood_club.dart';
import '../theme/widzew_colors.dart';

class NeighborhoodGroupsScreen extends StatelessWidget {
  final List<NeighborhoodClub> clubs;
  final String userName;
  final ValueChanged<String> onToggleJoin;
  final void Function(String clubId, String text) onSendMessage;

  const NeighborhoodGroupsScreen({
    super.key,
    required this.clubs,
    required this.userName,
    required this.onToggleJoin,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kluby i Grupy Widzewa')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        itemCount: clubs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final club = clubs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: WidzewColors.redSoft,
              child: Text('${club.memberCount}'),
            ),
            title: Text(club.name),
            subtitle: Text('${club.subDistrict} · ${club.description}'),
            isThreeLine: true,
            trailing: FilledButton.tonal(
              onPressed: () => onToggleJoin(club.id),
              child: Text(club.isJoined ? 'Dołączono' : 'Dołącz'),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _ClubChatScreen(
                  club: club,
                  userName: userName,
                  onSend: (text) => onSendMessage(club.id, text),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ClubChatScreen extends StatefulWidget {
  final NeighborhoodClub club;
  final String userName;
  final ValueChanged<String> onSend;

  const _ClubChatScreen({
    required this.club,
    required this.userName,
    required this.onSend,
  });

  @override
  State<_ClubChatScreen> createState() => _ClubChatScreenState();
}

class _ClubChatScreenState extends State<_ClubChatScreen> {
  final _controller = TextEditingController();
  late List<ClubMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.club.messages);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    setState(() {
      _messages = [
        ..._messages,
        ClubMessage(
          authorName: widget.userName,
          text: text,
          sentAt: DateTime.now(),
          isMine: true,
        ),
      ];
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messages;
    return Scaffold(
      appBar: AppBar(title: Text(widget.club.name)),
      body: Column(
        children: [
          if (!widget.club.isJoined)
            MaterialBanner(
              content: const Text('Dołącz do grupy, aby pisać na czacie klatki.'),
              actions: const [SizedBox.shrink()],
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final mine = message.isMine;
                return Align(
                  alignment:
                      mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: mine
                          ? WidzewColors.redSoft
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: mine
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.authorName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(message.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: widget.club.isJoined,
                      decoration: const InputDecoration(
                        hintText: 'Napisz do grupy…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.club.isJoined ? _send : null,
                    icon: const Icon(Icons.send),
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
