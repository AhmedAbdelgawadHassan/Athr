// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:athr/features/reminder/presentation/manager/cubits/reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReminderItem extends StatefulWidget {
  const ReminderItem({super.key, required this.reminder});
  final ReminderModel reminder;

  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    final base = Color(widget.reminder.color);
    final time = DateFormat('hh:mm a').format(widget.reminder.time);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: isActive
                ? [base.withOpacity(0.18), Colors.white]
                : [Colors.grey.withOpacity(0.08), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: base.withOpacity(0.18),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // ICON GLOW
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [base, base.withOpacity(0.6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: base.withOpacity(0.35),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      IconData(widget.reminder.icon, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const Gap(12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reminder.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.styleMedium18(context).copyWith(
                            height: 1.3,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 14, color: Colors.grey.shade600),
                            const Gap(4),
                            Text(
                              time,
                              style: AppStyles.styleRegular12(context).copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // DELETE
                  GestureDetector(
                    onTap: () => context
                        .read<ReminderCubit>()
                        .deleteReminder(widget.reminder.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),

              const Gap(14),

              Row(
                children: [
                  // CHIP
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: widget.reminder.isDaily
                          ? base.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Text(
                      widget.reminder.isDaily ? 'يومي 🔁' : 'مرة واحدة ⏱',
                      style: TextStyle(
                        color: widget.reminder.isDaily ? base : Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // STATUS
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isActive
                          ? base.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.08),
                    ),
                    child: Text(
                      isActive ? 'نشط 🔔' : 'متوقف ⛔',
                      style: TextStyle(
                        color: isActive ? base : Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Gap(8),

                  Transform.scale(
                    scale: 0.9,
                    child: Switch.adaptive(
                      value: isActive,
                      activeColor: base,
                      onChanged: (v) async {
                        setState(() => isActive = v);
                        await context
                            .read<ReminderCubit>()
                            .toggleReminder(widget.reminder, v);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
