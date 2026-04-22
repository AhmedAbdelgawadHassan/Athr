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

  final TextEditingController titleController = TextEditingController();

  int selectedIcon = Icons.star.codePoint;
  Color selectedColor = Colors.green;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isDaily = false;

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xffF5F4F1),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: SafeArea(
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(height: 16),
                Text(
                  "إضافة تذكير جديد",
                  style: AppStyles.styleSemiBold24(context),
                ),
                const Gap(20),
                ReminderTextfield(
                  titleController: titleController,
                ),
                const Gap(20),
                TimeReminderButton(
                  onTimeSelected: (time) {
                    selectedTime = time;
                  },
                ),
                const Gap(20),
                IconSelcetionSection(
                  onIconSelected: (icon) {
                    selectedIcon = icon;
                  },
                ),
                const Gap(20),
                ColorSelectorSection(
                  onColorSelected: (color) {
                    selectedColor = color;
                  },
                ),
                const Gap(20),
                DailyRepeatButton(
                  onRepeatChanged: (value) {
                    isDaily = value;
                  },
                ),
                const Gap(30),
                SaveReminderButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('من فضلك أدخل عنوان التذكير'),
                        ),
                      );
                      return;
                    }

                    final now = DateTime.now();

                    final reminderTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    await cubit.addReminder(
                      ReminderModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        time: reminderTime,
                        color: selectedColor.toARGB32(),
                        icon: selectedIcon,
                        isDaily: isDaily,
                      ),
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
