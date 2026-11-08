import 'package:flutter/material.dart';

class VerifiedTradespersonBadge extends StatelessWidget {
  final bool visible;
  final bool compact;

  const VerifiedTradespersonBadge({
    super.key,
    required this.visible,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final color = Theme.of(context).colorScheme.primary;
    return Chip(
      avatar: Icon(Icons.verified, size: compact ? 16 : 18, color: color),
      label: const Text('Zweryfikowany Fachowiec'),
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
    );
  }
}
