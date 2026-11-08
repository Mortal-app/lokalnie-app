import 'package:flutter/material.dart';

class QualityGuaranteeBadge extends StatelessWidget {
  final bool visible;
  final bool compact;

  const QualityGuaranteeBadge({
    super.key,
    required this.visible,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Chip(
      avatar: Icon(
        Icons.workspace_premium,
        size: compact ? 16 : 18,
        color: const Color(0xFFC9A227),
      ),
      label: const Text('Gwarancja Jakości'),
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
    );
  }
}
