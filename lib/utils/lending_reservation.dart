import 'package:flutter/material.dart';

class LendingReservation {
  static Future<void> requestDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
      helpText: 'Wybierz termin rezerwacji',
      cancelText: 'Anuluj',
      confirmText: 'Poproś',
    );
    if (picked == null || !context.mounted) return;
    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Poproszono o rezerwację na $day.$month.${picked.year}'),
        ),
      );
  }
}
