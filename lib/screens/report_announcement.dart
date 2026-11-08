import 'package:flutter/material.dart';

const reportReasons = ['Spam', 'Nieodpowiednia treść', 'Zła kategoria'];

Future<String?> showAnnouncementReportDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      var selected = reportReasons.first;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Zgłoś ogłoszenie'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final reason in reportReasons)
                  ListTile(
                    title: Text(reason),
                    leading: Icon(
                      selected == reason
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => setState(() => selected = reason),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Anuluj'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(selected),
                child: const Text('Zgłoś'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showReportAcceptedMessage(BuildContext context, String reason) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          'Dziękujemy. Zgłoszenie ($reason) przyjęte. Ogłoszenie ukryto.',
        ),
      ),
    );
}

void showReportSentThanks(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Dziękujemy, zgłoszenie wysłane')),
    );
}
