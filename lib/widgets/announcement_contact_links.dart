import 'dart:async';

import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../utils/neighbor_contact.dart';

class AnnouncementContactLinks extends StatelessWidget {
  final Announcement announcement;
  final bool compact;

  const AnnouncementContactLinks({
    super.key,
    required this.announcement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final phones = NeighborContact.phonesIn(
      announcement,
      fallback: !compact,
    );
    final emails = NeighborContact.emailsIn(announcement);
    return Wrap(
      spacing: 4,
      runSpacing: 0,
      children: [
        for (final phone in phones.take(compact ? 1 : 3))
          TextButton.icon(
            onPressed: () => unawaited(
              NeighborContact.copyAndCall(context, phone),
            ),
            icon: const Icon(Icons.phone_outlined, size: 18),
            label: Text(phone, overflow: TextOverflow.ellipsis),
          ),
        if (!compact)
          for (final email in emails.take(2))
            TextButton.icon(
              onPressed: () => unawaited(
                NeighborContact.copyAndEmail(context, email),
              ),
              icon: const Icon(Icons.mail_outline, size: 18),
              label: Text(email, overflow: TextOverflow.ellipsis),
            ),
      ],
    );
  }
}
