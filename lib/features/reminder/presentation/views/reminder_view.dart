import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:athr/features/reminder/presentation/manager/cubits/reminder_cubit.dart';
import 'package:athr/features/reminder/presentation/views/widgets/add_reminder_button.dart';
import 'package:athr/features/reminder/presentation/views/widgets/add_reminder_buttonsheet.dart';
import 'package:athr/features/reminder/presentation/views/widgets/advice_container.dart';
import 'package:athr/features/reminder/presentation/views/widgets/no_reminder_yet.dart';
import 'package:athr/features/reminder/presentation/views/widgets/reminder_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({super.key});

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderCubit>().loadReminders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'التذكيرات',
            style:
                AppStyles.styleMedium24(context).copyWith(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          actions: [
            GestureDetector(
              onTap: () {
                addReminderButtonSheet(context);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 69, 150, 126),
                    shape: BoxShape.circle),
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
        body: BlocBuilder<ReminderCubit, List<ReminderModel>>(
          builder: (context, reminders) {
           return  SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                 reminders.isEmpty? SliverToBoxAdapter(
                   child: Center(child: NoRemindersView())
                 )
                 : SliverList.separated(
                    separatorBuilder: (context, index) => const Gap(12),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) => ReminderItem(
                      reminder: reminders[index],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Gap(12),
                        AddReminderButton(
                          onPressed: () => addReminderButtonSheet(context),
                        ),
                        const Gap(12),
                        AdviceContainer(),
                        const Gap(12),
                      ],
                    ),
                  ),
                ],
              ),
          ),
              
              );
              },
        ));
  }
}