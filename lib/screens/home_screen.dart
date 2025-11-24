import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robofinal/models/robot_status.dart';
import 'package:robofinal/services/auth_service.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RobotStatus _status;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _status = MockAdminService.instance.getRobotStatus();
  }

  void _refresh() {
    setState(() {
      MockAdminService.instance.randomizeRobotStatus();
      _status = MockAdminService.instance.getRobotStatus();
    });
  }

  Color _getStatusColor(RobotActivity activity) {
    switch (activity) {
      case RobotActivity.idle:
        return const Color(0xFF0EA5E9);
      case RobotActivity.cleaning:
        return const Color(0xFF22C55E);
      case RobotActivity.disposing:
        return const Color(0xFFF59E0B);
      case RobotActivity.returning:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getStatusText(RobotActivity activity) {
    switch (activity) {
      case RobotActivity.idle:
        return 'Idle';
      case RobotActivity.cleaning:
        return 'Cleaning';
      case RobotActivity.disposing:
        return 'Disposing';
      case RobotActivity.returning:
        return 'Returning';
    }
  }

  String _getLocationText(RobotLocation location) {
    switch (location) {
      case RobotLocation.classroom:
        return 'Classroom';
      case RobotLocation.hallway:
        return 'Hallway';
      case RobotLocation.trashCan:
        return 'Trash Area';
    }
  }

  String _getConnectionText(ConnectionType type) {
    switch (type) {
      case ConnectionType.bluetooth:
        return 'Bluetooth';
      case ConnectionType.wifi:
        return 'WiFi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header with Welcome Message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${_authService.currentUser?.name ?? 'User'}! 👋',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dashboard',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monitor your RoboCleaner',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Robot Status Card
            _buildStatusCard(),
            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.battery_full,
                    label: 'Battery',
                    value: '${_status.batteryLevel}%',
                    color: _getBatteryColor(_status.batteryLevel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.delete_outline,
                    label: 'Trash Level',
                    value: '${_status.sensorData.trashLevel}%',
                    color: _getTrashColor(_status.sensorData.trashLevel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Connection Status Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: _status.connectionType == ConnectionType.wifi
                        ? Icons.wifi
                        : Icons.bluetooth_audio,
                    label: 'Connection',
                    value: _getConnectionText(_status.connectionType),
                    color:
                        _status.connectionStatus == ConnectionStatus.connected
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: _getLocationText(_status.location),
                    color: const Color(0xFF0EA5E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Action Buttons
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButtonsGrid(),
            const SizedBox(height: 24),

            // Activity Summary Card
            _buildActivitySummaryCard(),
            const SizedBox(height: 24),

            // Sensor Status Card
            _buildSensorStatusCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(_status.activity).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getStatusColor(_status.activity),
                      _getStatusColor(_status.activity).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Robot Status',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusText(_status.activity),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    _status.activity,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(
                      _status.activity,
                    ).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  _getStatusText(_status.activity).toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: _getStatusColor(_status.activity),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_status.activity == RobotActivity.cleaning)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cleaning Progress',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(_status.cleaningProgress * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF22C55E),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _status.cleaningProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBatteryColor(int level) {
    if (level > 50) return const Color(0xFF22C55E);
    if (level > 20) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Color _getTrashColor(int level) {
    if (level < 50) return const Color(0xFF22C55E);
    if (level < 80) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Widget _buildActionButtonsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildActionButton(
          icon: Icons.play_circle_outline,
          label: 'Start Cleaning',
          color: const Color(0xFF22C55E),
          onPressed: () {
            _showActionDialog('Start Cleaning');
          },
        ),
        _buildActionButton(
          icon: Icons.stop_circle_outlined,
          label: 'Stop Cleaning',
          color: const Color(0xFFEF4444),
          onPressed: () {
            _showActionDialog('Stop Cleaning');
          },
        ),
        _buildActionButton(
          icon: Icons.pause_circle_outline,
          label: 'Pause',
          color: const Color(0xFFF59E0B),
          onPressed: () {
            _showActionDialog('Pause');
          },
        ),
        _buildActionButton(
          icon: Icons.home_outlined,
          label: 'Return to Base',
          color: const Color(0xFF8B5CF6),
          onPressed: () {
            _showActionDialog('Return to Base');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySummaryCard() {
    final now = DateTime.now();
    final lastCleaned = now.subtract(const Duration(hours: 2, minutes: 30));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.history, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Activity Summary',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivityItem(
            icon: Icons.access_time,
            label: 'Last Cleaned',
            value:
                '${lastCleaned.hour}:${lastCleaned.minute.toString().padLeft(2, '0')} - 2h 30m ago',
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.location_on_outlined,
            label: 'Current Location',
            value: _getLocationText(_status.location),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.speed,
            label: 'Current Speed',
            value: '${_status.currentSpeed.toStringAsFixed(2)} m/s',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorStatusCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sensors, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Sensor Status',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSensorItem(
            label: 'Ultrasonic Sensor',
            value:
                '${_status.sensorData.ultrasonicDistance.toStringAsFixed(1)} cm',
            status: _status.sensorData.ultrasonicStatus,
          ),
          const SizedBox(height: 12),
          _buildSensorItem(
            label: 'Line Sensor',
            value: _status.sensorData.lineDetected
                ? 'Detected'
                : 'Not Detected',
            status: _status.sensorData.lineStatus,
          ),
          const SizedBox(height: 12),
          _buildSensorItem(
            label: 'Trash Sensor',
            value: '${_status.sensorData.trashLevel}% Full',
            status: _status.sensorData.trashStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorItem({
    required String label,
    required String value,
    required SensorStatus status,
  }) {
    Color statusColor;
    String statusText;

    switch (status) {
      case SensorStatus.normal:
        statusColor = const Color(0xFF22C55E);
        statusText = 'Normal';
        break;
      case SensorStatus.warning:
        statusColor = const Color(0xFFF59E0B);
        statusText = 'Warning';
        break;
      case SensorStatus.error:
        statusColor = const Color(0xFFEF4444);
        statusText = 'Error';
        break;
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
          ),
          child: Text(
            statusText,
            style: GoogleFonts.poppins(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  void _showActionDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF22C55E), width: 1.5),
        ),
        title: Text(
          action,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Execute $action command?',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$action command sent!',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF22C55E),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Execute',
              style: GoogleFonts.poppins(
                color: const Color(0xFF22C55E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
