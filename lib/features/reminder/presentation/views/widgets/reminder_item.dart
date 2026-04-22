import 'package:athr/core/utils/app_colors.dart';
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

  IconData _resolveReminderIcon(int codePoint) {
    // Keep icons as compile-time constants to support release icon tree-shaking.
    switch (codePoint) {
      case 0xe430:
        return Icons.wb_sunny_outlined;
      case 0xe3a4:
        return Icons.nightlight_round;
      case 0xe03a:
        return Icons.access_time;
      case 0xe25b:
        return Icons.favorite_border;
      case 0xe7f4:
        return Icons.notifications_none;
      case 0xe0ef:
        return Icons.menu_book_outlined;
      case 0xe541:
        return Icons.local_cafe_outlined;
      case 0xe2bd:
        return Icons.cloud_outlined;
      case 0xe3a9:
        return Icons.dark_mode_outlined;
      case 0xe838:
        return Icons.star;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Color(widget.reminder.color);
    final Color softColor = cardColor.withValues(alpha: 0.10);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cardColor.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  cardColor,
                  cardColor.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          const Gap(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: softColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _resolveReminderIcon(widget.reminder.icon),
                  color: cardColor,
                  size: 22,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reminder.title,
                      softWrap: true,
                      maxLines: null,
                      style: AppStyles.styleMedium18(context).copyWith(
                        color: const Color(0xff1E1E1E),
                        height: 1.3,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F8FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Color(0xff6B6B6B),
                            size: 15,
                          ),
                          const Gap(6),
                          Text(
                            DateFormat('hh:mm a').format(widget.reminder.time),
                            style: AppStyles.styleRegular12(
                              context,
                            ).copyWith(color: const Color(0xff6B6B6B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ReminderCubit>().deleteReminder(
                    widget.reminder.id,
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xffFFF1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const Gap(12),
          Divider(
            height: 1,
            color: const Color(0xffEAEAEA),
          ),
          const Gap(10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: widget.reminder.isDaily
                      ? AppColors.primaryColor.withValues(alpha: 0.12)
                      : const Color(0xffF3F3F3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.reminder.isDaily ? 'يومي' : 'مرة واحدة',
                  style: AppStyles.styleRegular12(context).copyWith(
                    color: widget.reminder.isDaily
                        ? AppColors.primaryColor
                        : const Color(0xff7A7A7A),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                isActive ? 'مفعل' : 'متوقف',
                style: AppStyles.styleRegular12(
                  context,
                ).copyWith(color: isActive ? AppColors.primaryColor : Colors.grey),
              ),
              const Gap(8),
              Switch.adaptive(
                value: isActive,
                activeThumbColor: AppColors.primaryColor,
                activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.3),
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
