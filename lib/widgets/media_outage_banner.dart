import 'package:flutter/material.dart';

import '../theme/widzew_ui.dart';


class MediaOutageBanner extends StatelessWidget {
  final int activeCount;
  final VoidCallback onOpen;

  const MediaOutageBanner({
    super.key,
    required this.activeCount,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (activeCount <= 0) return const SizedBox.shrink();
    return Material(
      elevation: 3,
      color: const Color(0xFF1565C0),
      borderRadius: WidzewUi.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        borderRadius: WidzewUi.borderRadius,
        splashColor: Colors.white24,
        child: const SizedBox(
          height: 44,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.water_drop_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pilne: awaria mediów na osiedlu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
