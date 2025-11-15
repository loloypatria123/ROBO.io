import 'package:flutter/material.dart';
import 'package:robofinal/screens/monitoring_screen.dart';
import 'package:robofinal/screens/notifications_screen.dart';
import 'package:robofinal/screens/schedules_screen.dart';
import 'package:robofinal/screens/settings_screen.dart';
import 'package:robofinal/screens/logs_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    MonitoringScreen(),
    SchedulesScreen(),
    LogsScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RoboCleaner DisposeBot – Admin')),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Logs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
