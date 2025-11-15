import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robofinal/models/alert.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final alerts = MockAdminService.instance.getAlerts();
    final formatter = DateFormat('MM-dd HH:mm');

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Card(
          child: ListTile(
            leading: Icon(_iconFor(alert.type)),
            title: Text(alert.title),
            subtitle: Text(
              '${alert.message}\n${formatter.format(alert.timestamp)}',
            ),
            isThreeLine: true,
            trailing: Wrap(
              spacing: 8,
              children: [
                if (alert.status == AlertStatus.active)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        MockAdminService.instance.acknowledgeAlert(alert.id);
                      });
                    },
                    child: const Text('Acknowledge'),
                  ),
                if (alert.status != AlertStatus.cleared)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        MockAdminService.instance.clearAlert(alert.id);
                      });
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(AlertType type) {
    switch (type) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
    }
  }
}
