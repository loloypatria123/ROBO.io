import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:robofinal/models/robot_status.dart';
import 'package:robofinal/services/auth_service.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late RobotStatus _status;
  final _authService = AuthService();
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _status = MockAdminService.instance.getRobotStatus();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Header with Welcome Message
            FadeTransition(
              opacity: _fadeController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${_authService.currentUser?.name ?? 'User'}! 👋',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor your RoboCleaner in real-time',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Robot Status Card
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: _buildStatusCard(),
            ),
            const SizedBox(height: 28),

            // Quick Stats Row
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.battery_full,
                      label: 'Battery',
                      value: '${_status.batteryLevel}%',
                      color: _getBatteryColor(_status.batteryLevel),
                    ),
                  ),
                  const SizedBox(width: 16),
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
            ),
            const SizedBox(height: 16),

            // Connection Status Row
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: Row(
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
                  const SizedBox(width: 16),
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
            ),
            const SizedBox(height: 32),

            // Quick Action Buttons
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: _buildActionButtonsGrid(),
            ),
            const SizedBox(height: 32),

            // Activity Summary Card
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: _buildActivitySummaryCard(),
            ),
            const SizedBox(height: 28),

            // Sensor Status Card
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: _buildSensorStatusCard(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(
                  _status.activity,
                ).withValues(alpha: 0.15),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getStatusColor(_status.activity),
                          _getStatusColor(
                            _status.activity,
                          ).withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(
                            _status.activity,
                          ).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Robot Status',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _getStatusText(_status.activity),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        _status.activity,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(
                          _status.activity,
                        ).withValues(alpha: 0.5),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      _getStatusText(_status.activity).toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: _getStatusColor(_status.activity),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              if (_status.activity == RobotActivity.cleaning) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cleaning Progress',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      '${(_status.cleaningProgress * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF22C55E),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _status.cleaningProgress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.11),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 18,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
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
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySummaryCard() {
    final now = DateTime.now();
    final lastCleaned = now.subtract(const Duration(hours: 2, minutes: 30));

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.08),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Activity Summary',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildActivityItem(
                icon: Icons.access_time,
                label: 'Last Cleaned',
                value:
                    '${lastCleaned.hour}:${lastCleaned.minute.toString().padLeft(2, '0')} - 2h 30m ago',
              ),
              const SizedBox(height: 18),
              _buildActivityItem(
                icon: Icons.location_on_outlined,
                label: 'Current Location',
                value: _getLocationText(_status.location),
              ),
              const SizedBox(height: 18),
              _buildActivityItem(
                icon: Icons.speed,
                label: 'Current Speed',
                value: '${_status.currentSpeed.toStringAsFixed(2)} m/s',
              ),
            ],
          ),
        ),
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Icon(icon, color: const Color(0xFF0EA5E9), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorStatusCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.08),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF0EA5E9)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sensors,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Sensor Status',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSensorItem(
                label: 'Ultrasonic Sensor',
                value:
                    '${_status.sensorData.ultrasonicDistance.toStringAsFixed(1)} cm',
                status: _status.sensorData.ultrasonicStatus,
              ),
              const SizedBox(height: 16),
              _buildSensorItem(
                label: 'Line Sensor',
                value: _status.sensorData.lineDetected
                    ? 'Detected'
                    : 'Not Detected',
                status: _status.sensorData.lineStatus,
              ),
              const SizedBox(height: 16),
              _buildSensorItem(
                label: 'Trash Sensor',
                value: '${_status.sensorData.trashLevel}% Full',
                status: _status.sensorData.trashStatus,
              ),
            ],
          ),
        ),
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
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.4),
              width: 0.8,
            ),
          ),
          child: Text(
            statusText,
            style: GoogleFonts.poppins(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
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
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF22C55E), width: 1.5),
        ),
        title: Text(
          action,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        content: Text(
          'Execute $action command?',
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
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
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  backgroundColor: const Color(0xFF22C55E),
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Text(
              'Execute',
              style: GoogleFonts.poppins(
                color: const Color(0xFF22C55E),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
