import 'package:flutter/material.dart';

import '../models/widzew_timeline.dart';

class WidzewTimelineScreen extends StatefulWidget {
  final List<TimelineEra> eras;

  const WidzewTimelineScreen({super.key, required this.eras});

  @override
  State<WidzewTimelineScreen> createState() => _WidzewTimelineScreenState();
}

class _WidzewTimelineScreenState extends State<WidzewTimelineScreen> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kapsuła czasu Widzewa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Jak budowano osiedla na Widzewie — oś czasu dziesięcioleci. Dotknij epoki.',
          ),
          const SizedBox(height: 16),
          for (final era in widget.eras) ...[
            InkWell(
              onTap: () => setState(
                () => _openId = _openId == era.id ? null : era.id,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _openId == era.id
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: _openId == era.id ? 88 : 36,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            era.decade,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(era.title),
                          if (_openId == era.id) ...[
                            const SizedBox(height: 6),
                            Text(era.body),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
