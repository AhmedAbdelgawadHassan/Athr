// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/tasbeeh/presentation/views/widgets/tasbeeh_button.dart';
import 'package:athr/features/tasbeeh/presentation/views/widgets/tasbeeh_row_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TasbeehView extends StatefulWidget {
  const TasbeehView({super.key});

  @override
  State<TasbeehView> createState() => _TasbeehViewState();
}

class _TasbeehViewState extends State<TasbeehView> {
  int count = 0;
  int total = 0;
  int rounds = 0;

  final int maxCount = 33;

  String currentZekr = "سبحان الله";

  final List<String> azkar = [
    "سبحان الله",
    "الحمد لله",
    "لا إله إلا الله",
    "الله أكبر",
    "سبحان الله وبحمده",
    "سبحان الله العظيم",
    "اللهم صلِّ على محمد",
    "اللهم اغفر لي",
    "أستغفر الله",
    "لا حول ولا قوة إلا بالله",
    "اللهم ارحمني",
    "اللهم ارزقني",
    "اللهم تب عليّ",
    "اللهم اهدني",
    "اللهم عافني",
    "اللهم اعف عني",
    "اللهم اجعلني من الصالحين",
    "اللهم اجعلني من الذاكرين",
    "اللهم اجعلني من الشاكرين",
    "اللهم تقبل مني",
  ];

  void increment() {
    setState(() {
      count++;
      total++;

      if (count == maxCount) {
        rounds++;
        count = 0;
      }
    });
  }

  void reset() {
    setState(() {
      count = 0;
      total = 0;
      rounds = 0;
    });
  }

  void changeZekr(String zekr) {
    setState(() {
      currentZekr = zekr;
      count = 0;
    });
  }

  double get progress => count / maxCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.08),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Text(
                "التسبيح",
                style: AppStyles.styleSemiBold24(context),
              ),

              const Gap(20),

              /// AZKAR
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: azkar.length,
                  itemBuilder: (context, index) {
                    final zekr = azkar[index];
                    final isSelected = zekr == currentZekr;

                    return GestureDetector(
                      onTap: (){
                     changeZekr(zekr);
                     total = 0;
                     rounds = 0;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            zekr,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Gap(20),

              /// MAIN CARD
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondaryColor,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ZEKR TEXT
                      Text(
                        currentZekr,
                        textAlign: TextAlign.center,
                        style: AppStyles.styleSemiBold24(context).copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),

                      /// CIRCLE WITH GLOW
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(
                                  AppColors.primaryColor),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$count",
                                style: AppStyles.styleMedium30(context)
                                    .copyWith(fontSize: 42),
                              ),
                              const Gap(4),
                              Text("من $maxCount"),
                            ],
                          )
                        ],
                      ),

                      /// BUTTON
                      TasbeehButton(onTap: increment),

                      /// BOTTOM
                      TasbeehRowButtons(
                        resetOnTap: reset,
                        total: total,
                        rounds: rounds,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
