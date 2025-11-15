import 'package:flutter/material.dart';
import 'package:robofinal/models/robot_status.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  RobotStatus _status = MockAdminService.instance.getRobotStatus();

  void _refresh() {
    setState(() {
      MockAdminService.instance.randomizeRobotStatus();
      _status = MockAdminService.instance.getRobotStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _refresh();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Robot Status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildRow('Activity', _status.activity.name),
                  _buildRow('Battery', '${_status.batteryLevel}%'),
                  _buildRow(
                    'Trash Container',
                    _status.trashFull ? 'Full' : 'OK',
                  ),
                  _buildRow(
                    'Connection',
                    '${_status.connectionType.name.toUpperCase()} – ${_status.connectionStatus.name}',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('Dispose'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
