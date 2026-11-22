import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_info.dart';
import '../l10n/app_localizations.dart';
import '../services/change_proposal_store.dart';

class ProposeChangeDialog {
  const ProposeChangeDialog._();

  static Future<void> show(
    BuildContext context, {
    required String userName,
  }) async {
    final controller = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('proposeChangeTitle')),
        content: TextField(
          controller: controller,
          maxLines: 5,
          minLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: dialogContext.tr('proposeChangeField'),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.tr('cancel')),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.of(dialogContext).pop(true);
            },
            child: Text(dialogContext.tr('send')),
          ),
        ],
      ),
    );
    final text = controller.text.trim();
    controller.dispose();
    if (!context.mounted) return;
    if (sent != true) return;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('proposalEmpty'))),
      );
      return;
    }
    await ChangeProposalStore.add(text, userName: userName);
    final uri = Uri(
      scheme: 'mailto',
      path: AppInfo.adminEmail,
      queryParameters: {
        'subject': 'Propozycja zmiany — Lokalnie',
        'body': '$userName:\n$text',
      },
    );
    try {
      await launchUrl(uri);
    } catch (_) {}
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('proposalSent'))),
    );
  }
}
