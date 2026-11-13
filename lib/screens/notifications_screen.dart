import 'package:flutter/material.dart';

import '../models/neighborhood_notification.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';

class NotificationCenterScreen extends StatefulWidget {
  final List<NeighborhoodNotification> notifications;
  final ValueChanged<NeighborhoodNotification> onOpenNotification;

  const NotificationCenterScreen({
    super.key,
    required this.notifications,
    required this.onOpenNotification,
  });

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late List<NeighborhoodNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(widget.notifications);
  }

  void _open(NeighborhoodNotification notification) {
    setState(() {
      _notifications = [
        for (final item in _notifications)
          if (item.readKey == notification.readKey)
            item.copyWith(isRead: true)
          else
            item,
      ];
    });
    widget.onOpenNotification(notification.copyWith(isRead: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Powiadomienia')),
      body: _notifications.isEmpty
          ? const Center(child: Text('Brak nowych powiadomień.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              shrinkWrap: false,
              itemCount: _notifications.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final isRead = notification.isRead;
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  color: isRead
                      ? Colors.grey.shade100
                      : const Color(0xFFFFF3E0),
                  child: ListTile(
                    leading: Icon(
                      notification.icon,
                      color: isRead ? Colors.grey : const Color(0xFFE65100),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        color: isRead
                            ? WidzewColors.inkMuted
                            : WidzewColors.ink,
                        fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      notification.body,
                      style: TextStyle(
                        color: isRead
                            ? WidzewColors.inkMuted
                            : WidzewColors.ink,
                      ),
                    ),
                    onTap: () => _open(notification),
                  ),
                );
              },
            ),
    );
  }
}
