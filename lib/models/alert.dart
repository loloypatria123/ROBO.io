enum AlertType { info, warning, error }

enum AlertStatus { active, acknowledged, cleared }

class Alert {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final AlertStatus status;

  const Alert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  Alert copyWith({AlertStatus? status}) {
    return Alert(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}
