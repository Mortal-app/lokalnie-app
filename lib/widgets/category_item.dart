import 'package:flutter/material.dart';

import '../theme/widzew_ui.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final String? displayLabel;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.selected = false,
    this.displayLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('category-$label'),
      color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: WidzewUi.borderRadius,
      child: InkWell(
        borderRadius: WidzewUi.borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 28,
                child: Text(
                  displayLabel ?? label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
