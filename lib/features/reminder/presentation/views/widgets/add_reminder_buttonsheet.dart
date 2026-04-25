import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:athr/features/reminder/presentation/manager/cubits/reminder_cubit.dart';
import 'package:athr/features/reminder/presentation/views/widgets/color_selector_section.dart';
import 'package:athr/features/reminder/presentation/views/widgets/daily_repeat_button.dart';
import 'package:athr/features/reminder/presentation/views/widgets/icon_selcetion_section.dart';
import 'package:athr/features/reminder/presentation/views/widgets/reminder_textfield.dart';
import 'package:athr/features/reminder/presentation/views/widgets/save_reminder_button.dart';
import 'package:athr/features/reminder/presentation/views/widgets/time_reminder_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

void addReminderButtonSheet(BuildContext context) {
  final cubit = context.read<ReminderCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xffF5F4F1),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _AddReminderSheet(),
    ),
  );
}

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet();

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final TextEditingController _titleController = TextEditingController();

  // ✅ null عشان نعرف لو المستخدم اختار ولا لأ
  int? _selectedIcon;
  Color _selectedColor = Colors.green;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDaily = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
            const SizedBox(height: 16),
            Text("إضافة تذكير جديد", style: AppStyles.styleSemiBold24(context)),
            const Gap(20),
            ReminderTextfield(titleController: _titleController),
            const Gap(20),
            TimeReminderButton(
              onTimeSelected: (time) => setState(() => _selectedTime = time),
            ),
            const Gap(20),
            IconSelcetionSection(
              onIconSelected: (icon) => setState(() => _selectedIcon = icon),
            ),
            const Gap(20),
            ColorSelectorSection(
              onColorSelected: (color) => setState(() => _selectedColor = color),
            ),
            const Gap(20),
            DailyRepeatButton(
              onRepeatChanged: (value) => setState(() => _isDaily = value),
            ),
            const Gap(30),
            SaveReminderButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('من فضلك أدخل عنوان التذكير')),
                  );
                  return;
                }

                final now = DateTime.now();
                final reminderTime = DateTime(
                  now.year, now.month, now.day,
                  _selectedTime.hour, _selectedTime.minute,
                );

                await context.read<ReminderCubit>().addReminder(
                  ReminderModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text.trim(),
                    time: reminderTime,
                    color: _selectedColor.toARGB32(),
                    // ✅ لو مختارش أيقونة يبقى النجمة default
                    icon: _selectedIcon ?? Icons.star.codePoint,
                    isDaily: _isDaily,
                  ),
                );

                if (context.mounted) Navigator.pop(context);
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}