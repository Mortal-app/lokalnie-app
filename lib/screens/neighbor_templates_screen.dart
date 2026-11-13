import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/neighbor_template.dart';
import '../utils/flutter_runtime.dart';

class NeighborTemplatesScreen extends StatelessWidget {
  final List<NeighborTemplate> templates;

  const NeighborTemplatesScreen({super.key, required this.templates});

  bool get _isWidgetTest => isFlutterWidgetTest;

  Future<void> _copy(BuildContext context, NeighborTemplate template) async {
    if (!_isWidgetTest) {
      await Clipboard.setData(ClipboardData(text: template.body));
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Skopiowano wzór: ${template.title}')),
    );
  }

  void _preview(BuildContext context, NeighborTemplate template) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(template.title),
          content: SingleChildScrollView(child: Text(template.body)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Zamknij'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _copy(context, template);
              },
              child: const Text('Kopiuj wzór'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wzory umów i oświadczeń')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Gotowe szablony do podglądu i skopiowania: użyczenie sprzętu, zalanie, zgłoszenie do spółdzielni.',
          ),
          const SizedBox(height: 12),
          for (final template in templates)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(template.title),
                subtitle: const Text('Podgląd i kopiowanie wzoru'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _preview(context, template),
              ),
            ),
        ],
      ),
    );
  }
}
