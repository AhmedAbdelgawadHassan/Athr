import 'package:athr/core/services/notification_service.dart';
import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ReminderCubit extends Cubit<List<ReminderModel>> {
  ReminderCubit() : super([]);

  final Box reminderBox = Hive.box('reminders');

  Future<void> loadReminders() async {
    final List<ReminderModel> reminders = [];
    final List<dynamic> invalidKeys = [];

    for (final dynamic key in reminderBox.keys) {
      final dynamic item = reminderBox.get(key);
      try {
        if (item is ReminderModel) { reminders.add(item); continue; }
        if (item is Map) { reminders.add(ReminderModel.fromMap(item)); continue; }
        invalidKeys.add(key);
      } catch (_) { invalidKeys.add(key); }
    }

    if (invalidKeys.isNotEmpty) reminderBox.deleteAll(invalidKeys);
    emit(reminders);

    for (final reminder in reminders) {
      await NotificationService.instance.scheduleReminder(
        id: reminder.id,
        title: reminder.title,
        time: reminder.time,
        isDaily: reminder.isDaily,
      );
    }
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      reminderBox.put(reminder.id, reminder.toMap());
    } catch (_) { return; }

    await NotificationService.instance.scheduleReminder(
      id: reminder.id,
      title: reminder.title,
      time: reminder.time,
      isDaily: reminder.isDaily,
    );
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    try {
      reminderBox.delete(id);
    } catch (_) { return; }

    await NotificationService.instance.cancelReminder(id); // ✅
    await loadReminders();
  }
}