enum RobotActivity { idle, cleaning, disposing, returning }

enum ConnectionType { bluetooth, wifi }

enum ConnectionStatus { connected, disconnected }

enum RobotLocation { classroom, hallway, trashCan }

enum SensorStatus { normal, warning, error }

class SensorData {
  final double ultrasonicDistance; // in cm
  final SensorStatus ultrasonicStatus;
  final bool lineDetected;
  final SensorStatus lineStatus;
  final int trashLevel; // percentage
  final SensorStatus trashStatus;

  const SensorData({
    required this.ultrasonicDistance,
    required this.ultrasonicStatus,
    required this.lineDetected,
    required this.lineStatus,
    required this.trashLevel,
    required this.trashStatus,
  });
}

class RobotStatus {
  final RobotActivity activity;
  final int batteryLevel;
  final bool trashFull;
  final ConnectionType connectionType;
  final ConnectionStatus connectionStatus;
  final RobotLocation location;
  final double cleaningProgress;
  final SensorData sensorData;
  final double currentSpeed; // in m/s
  final String lastMovement;

  const RobotStatus({
    required this.activity,
    required this.batteryLevel,
    required this.trashFull,
    required this.connectionType,
    required this.connectionStatus,
    required this.location,
    this.cleaningProgress = 0.0,
    required this.sensorData,
    this.currentSpeed = 0.0,
    this.lastMovement = 'Stationary',
  });
}
