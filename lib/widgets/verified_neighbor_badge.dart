import 'package:flutter/material.dart';

import '../models/neighbor_trust.dart';

class VerifiedNeighborBadge extends StatelessWidget {
  final String authorName;
  final int likesCount;
  final bool compact;
  final TextStyle? nameStyle;

  const VerifiedNeighborBadge({
    super.key,
    required this.authorName,
    this.likesCount = 0,
    this.compact = false,
    this.nameStyle,
  });

  NeighborTrust get _trust =>
      NeighborTrust.forAuthor(authorName, likesCount: likesCount);

  @override
  Widget build(BuildContext context) {
    final name = Text(
      authorName,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: nameStyle ?? Theme.of(context).textTheme.bodySmall,
    );
    if (!_trust.isVerified) return name;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: name),
        const SizedBox(width: 4),
        Tooltip(
          message: 'Zweryfikowany Sąsiad',
          child: Icon(
            Icons.verified,
            size: compact ? 14 : 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Zweryfikowany Sąsiad',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
