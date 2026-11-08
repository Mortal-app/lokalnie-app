import 'package:flutter/material.dart';

import '../models/neighbor_quest.dart';

class NeighborQuestsScreen extends StatefulWidget {
  final int points;
  final List<String> unlockedIds;
  final ValueChanged<String> onUnlock;

  const NeighborQuestsScreen({
    super.key,
    required this.points,
    required this.unlockedIds,
    required this.onUnlock,
  });

  @override
  State<NeighborQuestsScreen> createState() => _NeighborQuestsScreenState();
}

class _NeighborQuestsScreenState extends State<NeighborQuestsScreen> {
  late int _points;
  late List<String> _unlocked;

  @override
  void initState() {
    super.initState();
    _points = widget.points;
    _unlocked = List.of(widget.unlockedIds);
  }

  void _unlock(String id) {
    if (_unlocked.contains(id)) return;
    setState(() {
      _unlocked = [..._unlocked, id];
      _points += 25;
    });
    widget.onUnlock(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Odznaki aktywnego sąsiada')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Punkty aktywności: $_points',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pomocna Dłoń, Eko-Sąsiad i Lokalny Autor — odznaki w profilu.',
          ),
          const SizedBox(height: 12),
          for (final badge in NeighborQuestBadge.catalog)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  _unlocked.contains(badge.id)
                      ? Icons.emoji_events
                      : Icons.emoji_events_outlined,
                  color: _unlocked.contains(badge.id) ? Colors.amber : null,
                ),
                title: Text(badge.title),
                subtitle: Text(badge.description),
                trailing: _unlocked.contains(badge.id)
                    ? const Text('Zdobyta')
                    : TextButton(
                        onPressed: () => _unlock(badge.id),
                        child: const Text('Odbierz'),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
