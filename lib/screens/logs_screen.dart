import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robofinal/models/log_entry.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = MockAdminService.instance.getLogs();
    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    if (logs.isEmpty) {
      return const Center(child: Text('No logs yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          child: ListTile(
            leading: Icon(_iconFor(log.type)),
            title: Text(log.description),
            subtitle: Text(formatter.format(log.timestamp)),
          ),
        );
      },
    );
  }

  IconData _iconFor(LogType type) {
    switch (type) {
      case LogType.cleaning:
        return Icons.cleaning_services;
      case LogType.disposal:
        return Icons.delete_sweep;
      case LogType.error:
        return Icons.error_outline;
    }
  }
}
