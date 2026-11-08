import 'package:flutter/material.dart';

class ActivityReportScreen extends StatelessWidget {
  final VoidCallback onExportCsv;
  final VoidCallback onExportPdfText;

  const ActivityReportScreen({
    super.key,
    required this.onExportCsv,
    required this.onExportPdfText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eksport historii zgłoszeń')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Pełny raport aktywności w aplikacji — CSV lub tekst w układzie dokumentu do zapisu w pamięci telefonu (schowek).',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onExportCsv,
            icon: const Icon(Icons.table_chart_outlined),
            label: const Text('Eksportuj CSV'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onExportPdfText,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Eksportuj raport PDF (tekst)'),
          ),
        ],
      ),
    );
  }
}
