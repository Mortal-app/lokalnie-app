import 'package:flutter/material.dart';

import '../models/neighborhood_poll.dart';
import '../theme/widzew_colors.dart';

class CommunityPolls extends StatelessWidget {
  final List<NeighborhoodPoll> polls;
  final void Function(String pollId, int optionIndex) onVote;

  const CommunityPolls({
    super.key,
    required this.polls,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    if (polls.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Głosowania Sąsiedzkie',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final poll in polls) ...[
            _PollCard(poll: poll, onVote: onVote),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PollCard extends StatelessWidget {
  final NeighborhoodPoll poll;
  final void Function(String pollId, int optionIndex) onVote;

  const _PollCard({required this.poll, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll.question,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            for (var index = 0; index < poll.options.length; index++) ...[
              _PollOptionRow(
                poll: poll,
                index: index,
                onVote: () => onVote(poll.id, index),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '${poll.totalVotes} głosów sąsiadów',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PollOptionRow extends StatelessWidget {
  final NeighborhoodPoll poll;
  final int index;
  final VoidCallback onVote;

  const _PollOptionRow({
    required this.poll,
    required this.index,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final option = poll.options[index];
    final percent = poll.percentFor(index);
    final selected = poll.selectedOptionIndex == index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(option.label)),
            if (!poll.hasVoted)
              TextButton(
                key: ValueKey('poll-vote-${poll.id}-$index'),
                onPressed: onVote,
                child: const Text('Głosuj'),
              )
            else
              Text(
                '${(percent * 100).round()}%',
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? WidzewColors.red : null,
                ),
              ),
          ],
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 14,
                value: value,
                backgroundColor: WidzewColors.redSoft,
                color: selected ? WidzewColors.red : const Color(0xFFE57373),
              ),
            );
          },
        ),
      ],
    );
  }
}
