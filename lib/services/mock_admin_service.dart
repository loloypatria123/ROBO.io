import 'dart:math';

import 'package:robofinal/models/alert.dart';
import 'package:robofinal/models/cleaning_schedule.dart';
import 'package:robofinal/models/log_entry.dart';
import 'package:robofinal/models/robot_status.dart';

class MockAdminService {
  MockAdminService._();

  static final MockAdminService instance = MockAdminService._();

  final List<CleaningSchedule> _schedules = [
    CleaningSchedule(
      id: '1',
      classroom: 'Room 101',
      startTime: DateTime.now().add(const Duration(hours: 1)),
      duration: const Duration(minutes: 45),
      status: CleaningStatus.scheduled,
    ),
    CleaningSchedule(
      id: '2',
      classroom: 'Lab 202',
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      duration: const Duration(minutes: 60),
      status: CleaningStatus.completed,
    ),
  ];

  RobotStatus _status = const RobotStatus(
    activity: RobotActivity.idle,
    batteryLevel: 78,
    trashFull: false,
    connectionType: ConnectionType.wifi,
    connectionStatus: ConnectionStatus.connected,
    location: RobotLocation.classroom,
    cleaningProgress: 0.0,
    sensorData: SensorData(
      ultrasonicDistance: 25.5,
      ultrasonicStatus: SensorStatus.normal,
      lineDetected: true,
      lineStatus: SensorStatus.normal,
      trashLevel: 35,
      trashStatus: SensorStatus.normal,
    ),
    currentSpeed: 0.0,
    lastMovement: 'Stationary',
  );

  final List<LogEntry> _logs = [];

  final List<Alert> _alerts = [
    Alert(
      id: 'a1',
      type: AlertType.error,
      title: 'Trash Container Full',
      message:
          'The trash container has reached 100% capacity. Disposal required immediately.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      status: AlertStatus.active,
    ),
    Alert(
      id: 'a2',
      type: AlertType.error,
      title: 'Robot Stuck',
      message:
          'Robot is stuck near Classroom 305. Manual intervention may be required.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: AlertStatus.active,
    ),
    Alert(
      id: 'a3',
      type: AlertType.info,
      title: 'Cleaning Complete',
      message:
          'Successfully completed cleaning of Hallway B. Duration: 45 minutes.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      status: AlertStatus.acknowledged,
    ),
    Alert(
      id: 'a4',
      type: AlertType.warning,
      title: 'Low Battery Alert',
      message:
          'Battery level is at 18%. Robot will return to charging station soon.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      status: AlertStatus.active,
    ),
    Alert(
      id: 'a5',
      type: AlertType.info,
      title: 'Disposal Complete',
      message:
          'Trash has been successfully disposed at the main disposal unit.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      status: AlertStatus.acknowledged,
    ),
    Alert(
      id: 'a6',
      type: AlertType.info,
      title: 'Schedule Reminder',
      message: 'Upcoming cleaning scheduled for Room 101 in 30 minutes.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: AlertStatus.acknowledged,
    ),
  ];

  List<CleaningSchedule> getSchedules() {
    return List.unmodifiable(_schedules);
  }

  void addSchedule(CleaningSchedule schedule) {
    _schedules.add(schedule);
  }

  void updateSchedule(CleaningSchedule updated) {
    final index = _schedules.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _schedules[index] = updated;
    }
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s.id == id);
  }

  List<CleaningSchedule> searchSchedules({
    DateTime? date,
    String? classroom,
    CleaningStatus? status,
  }) {
    return _schedules.where((s) {
      final bool matchesDate =
          date == null ||
          (s.startTime.year == date.year &&
              s.startTime.month == date.month &&
              s.startTime.day == date.day);
      final bool matchesClassroom =
          classroom == null || classroom.isEmpty || s.classroom == classroom;
      final bool matchesStatus = status == null || s.status == status;
      return matchesDate && matchesClassroom && matchesStatus;
    }).toList();
  }

  RobotStatus getRobotStatus() {
    return _status;
  }

  void randomizeRobotStatus() {
    final rand = Random();
    final trashLevel = rand.nextInt(101);
    final distance = rand.nextDouble() * 100;
    _status = RobotStatus(
      activity: RobotActivity.values[rand.nextInt(RobotActivity.values.length)],
      batteryLevel: rand.nextInt(101),
      trashFull: rand.nextBool(),
      connectionType: rand.nextBool()
          ? ConnectionType.bluetooth
          : ConnectionType.wifi,
      connectionStatus: rand.nextBool()
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      location: RobotLocation.values[rand.nextInt(RobotLocation.values.length)],
      cleaningProgress: rand.nextDouble(),
      sensorData: SensorData(
        ultrasonicDistance: distance,
        ultrasonicStatus: distance < 10
            ? SensorStatus.warning
            : distance < 5
            ? SensorStatus.error
            : SensorStatus.normal,
        lineDetected: rand.nextBool(),
        lineStatus: rand.nextBool()
            ? SensorStatus.normal
            : SensorStatus.warning,
        trashLevel: trashLevel,
        trashStatus: trashLevel > 80
            ? SensorStatus.error
            : trashLevel > 60
            ? SensorStatus.warning
            : SensorStatus.normal,
      ),
      currentSpeed: rand.nextDouble() * 0.5,
      lastMovement: [
        'Forward',
        'Backward',
        'Left Turn',
        'Right Turn',
        'Stationary',
      ][rand.nextInt(5)],
    );
  }

  List<LogEntry> getLogs() {
    return List.unmodifiable(_logs);
  }

  void addLog(LogEntry log) {
    _logs.add(log);
  }

  List<Alert> getAlerts() {
    return List.unmodifiable(_alerts);
  }

  void acknowledgeAlert(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        status: AlertStatus.acknowledged,
      );
    }
  }

  void clearAlert(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(status: AlertStatus.cleared);
    }
  }
}
