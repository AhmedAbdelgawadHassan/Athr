import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimeReminderButton extends StatefulWidget {
  const TimeReminderButton({super.key, required this.onTimeSelected});
  final ValueChanged<TimeOfDay> onTimeSelected;

  @override
  State<TimeReminderButton> createState() => _TimeReminderButtonState();
}

class _TimeReminderButtonState extends State<TimeReminderButton> {
  TimeOfDay? selectedTime;
  String ampm = "AM";

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("وقت التذكير  :", style: AppStyles.styleMedium16(context)),
        const Gap(20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
          ),
          onPressed: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              // show time picker
              context: context,
              initialTime: TimeOfDay.now(), // show current time
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  // set time format
                  data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: false,
                      disableAnimations: true,
                      supportsAnnounce: true),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              setState(() {
                selectedTime = pickedTime;
                ampm = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
              });
              widget.onTimeSelected(pickedTime);
            }
          },
          child: Text(
            selectedTime == null
                ? 'اختر وقت التذكير'
                : '${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} $ampm',
            style:
                AppStyles.styleMedium16(context).copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
