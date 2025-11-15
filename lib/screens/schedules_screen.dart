import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robofinal/models/cleaning_schedule.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  void _openForm({CleaningSchedule? schedule}) async {
    final result = await showDialog<CleaningSchedule>(
      context: context,
      builder: (context) => _ScheduleFormDialog(schedule: schedule),
    );

    if (result != null) {
      setState(() {
        if (schedule == null) {
          MockAdminService.instance.addSchedule(result);
        } else {
          MockAdminService.instance.updateSchedule(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedules = MockAdminService.instance.getSchedules();

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final s = schedules[index];
          return Card(
            child: ListTile(
              title: Text(
                '${s.classroom} – ${_dateFormat.format(s.startTime)}',
              ),
              subtitle: Text(
                'Duration: ${s.duration.inMinutes} min • Status: ${s.status.name}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _openForm(schedule: s);
                  } else if (value == 'delete') {
                    setState(() {
                      MockAdminService.instance.deleteSchedule(s.id);
                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Schedule'),
      ),
    );
  }
}

class _ScheduleFormDialog extends StatefulWidget {
  final CleaningSchedule? schedule;

  const _ScheduleFormDialog({this.schedule});

  @override
  State<_ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<_ScheduleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _classroomController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _durationController;
  CleaningStatus _status = CleaningStatus.scheduled;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _classroomController = TextEditingController(text: s?.classroom ?? '');
    if (s != null) {
      _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(s.startTime),
      );
      _timeController = TextEditingController(
        text: DateFormat('HH:mm').format(s.startTime),
      );
      _durationController = TextEditingController(
        text: s.duration.inMinutes.toString(),
      );
      _status = s.status;
    } else {
      _dateController = TextEditingController();
      _timeController = TextEditingController();
      _durationController = TextEditingController(text: '45');
    }
  }

  @override
  void dispose() {
    _classroomController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final initial = widget.schedule?.startTime ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _pickTime() async {
    final initial = TimeOfDay.fromDateTime(
      widget.schedule?.startTime ?? DateTime.now(),
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final dateText = _dateController.text;
    final timeText = _timeController.text;
    final durationMinutes = int.tryParse(_durationController.text) ?? 45;

    final dateParts = dateText.split('-');

    DateTime startTime;
    if (dateParts.length == 3) {
      final now = DateTime.now();
      TimeOfDay timeOfDay;
      try {
        final parsed = TimeOfDay(
          hour: int.parse(timeText.split(':')[0]),
          minute: int.parse(timeText.split(':')[1]),
        );
        timeOfDay = parsed;
      } catch (_) {
        timeOfDay = TimeOfDay.fromDateTime(now);
      }
      startTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        timeOfDay.hour,
        timeOfDay.minute,
      );
    } else {
      startTime = DateTime.now();
    }

    final schedule = CleaningSchedule(
      id:
          widget.schedule?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      classroom: _classroomController.text,
      startTime: startTime,
      duration: Duration(minutes: durationMinutes),
      status: _status,
    );

    Navigator.of(context).pop(schedule);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule == null ? 'Add Schedule' : 'Edit Schedule'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _classroomController,
                decoration: const InputDecoration(labelText: 'Classroom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter classroom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (yyyy-MM-dd)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time (HH:mm)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
              ),
              DropdownButtonFormField<CleaningStatus>(
                value: _status,
                items: CleaningStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
