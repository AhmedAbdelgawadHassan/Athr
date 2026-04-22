import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReminderTextfield extends StatelessWidget {
  const ReminderTextfield({super.key, required this.titleController});
  final TextEditingController titleController;  // to get text that user enters

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("عنوان التذكير", style: AppStyles.styleMedium16(context)),
        Gap(5),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
              hintText: 'مثال: صلاة الضحى، قراءة ورد...',
              hintStyle: AppStyles.styleRegular14(context),
              fillColor: Colors.white,
              filled: true,
              
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xffD4AF37), width: 2))),
        ),
      ],
    );
  }
}
