import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          title: Text('Connection Settings'),
          subtitle: Text('Configure Bluetooth or Wi-Fi connection'),
          leading: Icon(Icons.wifi),
        ),
        const Divider(),
        const ListTile(
          title: Text('Calibration & Motors'),
          subtitle: Text('Calibrate sensors or adjust motor settings'),
          leading: Icon(Icons.tune),
        ),
        const Divider(),
        const ListTile(
          title: Text('System Maintenance'),
          subtitle: Text('Reset data, update firmware, restart robot'),
          leading: Icon(Icons.build_circle_outlined),
        ),
        const Divider(),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.logout),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
