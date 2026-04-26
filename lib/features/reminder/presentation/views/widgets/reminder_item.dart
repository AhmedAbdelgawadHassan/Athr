// Ultra modern Islamic Reminder Item with Dark/Light toggle
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:athr/features/reminder/presentation/manager/cubits/reminder_cubit.dart';

class ReminderItem extends StatefulWidget {
  const ReminderItem({super.key, required this.reminder});
  final ReminderModel reminder;

  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  bool isActive = true;
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    final base = Color(widget.reminder.color);
    final time = DateFormat('hh:mm a').format(widget.reminder.time);

    // ignore: unused_local_variable
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subText = isDark ? Colors.white70 : Colors.black54;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isActive
              ? [base.withOpacity(0.8), base.withOpacity(0.2)]
              : [Colors.grey.shade600, Colors.grey.shade300],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  // ICON with glow
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [base, base.withOpacity(0.5)],
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: base.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      IconData(widget.reminder.icon, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                    ),
                  ),

                  const Gap(12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reminder.title,
                          style: AppStyles.styleMedium18(context).copyWith(
                            color: textColor,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: subText),
                            const Gap(4),
                            Text(
                              time,
                              style: TextStyle(color: subText, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // LIGHT/DARK TOGGLE BUTTON
                  IconButton(
                    onPressed: () {
                      setState(() => isDark = !isDark);
                    },
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: base,
                    ),
                  ),

                  // DELETE
                  IconButton(
                    onPressed: () => context
                        .read<ReminderCubit>()
                        .deleteReminder(widget.reminder.id),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.redAccent,
                  ),
                ],
              ),

              const Gap(14),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: isDark
                          ? base.withOpacity(0.2)
                          : base.withOpacity(0.1),
                    ),
                    child: Text(
                      widget.reminder.isDaily ? 'يومي 🔁' : 'مرة واحدة ⏱',
                      style: TextStyle(
                        color: base,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isActive ? 'نشط 🔔' : 'متوقف ⛔',
                      key: ValueKey(isActive),
                      style: TextStyle(
                        color: isActive ? base : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Gap(8),

                  Switch.adaptive(
                    value: isActive,
                    activeColor: base,
                    onChanged: (v) async {
                      setState(() => isActive = v);
                      await context
                          .read<ReminderCubit>()
                          .toggleReminder(widget.reminder, v);
                    },
                  ),
                ],
              ),

              const Gap(10),

              // Decorative Islamic Quote
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isActive ? 1 : 0.3,
                child: Text(
                  '﴿ وَأَقِمِ الصَّلَاةَ لِذِكْرِي ﴾',
                  style: TextStyle(
                    fontSize: 11,
                    color: subText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
