import 'package:flutter/material.dart';
import 'package:robofinal/models/user.dart';
import 'package:robofinal/screens/home_screen.dart';
import 'package:robofinal/screens/monitoring_screen.dart';
import 'package:robofinal/screens/notifications_screen.dart';
import 'package:robofinal/screens/schedules_screen.dart';
import 'package:robofinal/screens/settings_screen.dart';
import 'package:robofinal/screens/logs_screen.dart';
import 'package:robofinal/services/auth_service.dart'; // Used for session management

class MainShell extends StatefulWidget {
  final UserRole? userRole;

  const MainShell({super.key, this.userRole});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  late final AuthService _authService;

  // Admin pages (all features)
  final _adminPages = const [
    HomeScreen(),
    MonitoringScreen(),
    SchedulesScreen(),
    LogsScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  // User pages (limited features)
  final _userPages = const [
    HomeScreen(),
    MonitoringScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  bool get _isAdmin =>
      widget.userRole == UserRole.admin || _authService.isAdmin;

  List<Widget> get _currentPages => _isAdmin ? _adminPages : _userPages;

  @override
  Widget build(BuildContext context) {
    final roleLabel = _isAdmin ? 'Admin' : 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RoboCleaner DisposeBot – $roleLabel',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: _currentPages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: _isAdmin
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),
                  label: 'Monitoring',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: 'Schedules',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Logs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Alerts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),
                  label: 'Monitoring',
                ),
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
