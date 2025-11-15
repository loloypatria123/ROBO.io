import 'package:flutter/foundation.dart';

enum CleaningStatus { scheduled, inProgress, completed, canceled }

@immutable
class CleaningSchedule {
  final String id;
  final String classroom;
  final DateTime startTime;
  final Duration duration;
  final CleaningStatus status;

  const CleaningSchedule({
    required this.id,
    required this.classroom,
    required this.startTime,
    required this.duration,
    required this.status,
  });

  CleaningSchedule copyWith({
    String? id,
    String? classroom,
    DateTime? startTime,
    Duration? duration,
    CleaningStatus? status,
  }) {
    return CleaningSchedule(
      id: id ?? this.id,
      classroom: classroom ?? this.classroom,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}
