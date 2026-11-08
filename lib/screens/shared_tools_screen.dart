import 'package:flutter/material.dart';

import '../models/shared_tool.dart';

class SharedToolsScreen extends StatefulWidget {
  final List<SharedTool> tools;
  final void Function(String id, String date) onReserve;

  const SharedToolsScreen({
    super.key,
    required this.tools,
    required this.onReserve,
  });

  @override
  State<SharedToolsScreen> createState() => _SharedToolsScreenState();
}

class _SharedToolsScreenState extends State<SharedToolsScreen> {
  late List<SharedTool> _tools;

  @override
  void initState() {
    super.initState();
    _tools = List.of(widget.tools);
  }

  Future<void> _reserve(SharedTool tool) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 10, 29),
      firstDate: DateTime(2026, 10, 1),
      lastDate: DateTime(2027, 12, 31),
    );
    if (picked == null) return;
    final date =
        '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() {
      _tools = _tools
          .map(
            (item) => item.id == tool.id
                ? item.copyWith(
                    reservedDates: [...item.reservedDates, date],
                  )
                : item,
          )
          .toList();
    });
    widget.onReserve(tool.id, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magazyn narzędzi spółdzielni')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Sprzęt klubu mieszkańca: drabina, odkurzacz piorący, myjka. Rezerwacja na dzień.',
          ),
          const SizedBox(height: 12),
          for (final tool in _tools)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(tool.description),
                    const SizedBox(height: 6),
                    Text(
                      tool.reservedDates.isEmpty
                          ? 'Brak rezerwacji'
                          : 'Zajęte: ${tool.reservedDates.join(', ')}',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _reserve(tool),
                        child: const Text('Zarezerwuj dzień'),
                      ),
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
