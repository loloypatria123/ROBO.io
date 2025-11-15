enum LogType { cleaning, disposal, error }

class LogEntry {
  final String id;
  final LogType type;
  final DateTime timestamp;
  final String description;
  final String? classroom;
  final Duration? duration;

  const LogEntry({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.description,
    this.classroom,
    this.duration,
  });
}
