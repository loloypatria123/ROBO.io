enum RobotActivity { idle, cleaning, disposing, returning }

enum ConnectionType { bluetooth, wifi }

enum ConnectionStatus { connected, disconnected }

class RobotStatus {
  final RobotActivity activity;
  final int batteryLevel;
  final bool trashFull;
  final ConnectionType connectionType;
  final ConnectionStatus connectionStatus;

  const RobotStatus({
    required this.activity,
    required this.batteryLevel,
    required this.trashFull,
    required this.connectionType,
    required this.connectionStatus,
  });
}
