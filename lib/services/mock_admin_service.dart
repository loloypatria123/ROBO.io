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
  );

  final List<LogEntry> _logs = [];

  final List<Alert> _alerts = [
    Alert(
      id: 'a1',
      type: AlertType.warning,
      title: 'Trash almost full',
      message: 'Dispose bin in Hallway 3 is at 85%.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: AlertStatus.active,
    ),
    Alert(
      id: 'a2',
      type: AlertType.info,
      title: 'Cleaning complete',
      message: 'Room 101 cleaning cycle finished.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
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
