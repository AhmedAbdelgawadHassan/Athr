// ignore_for_file: deprecated_member_use

import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/utils/app_assets.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/core/widgets/header_item.dart';
import 'package:athr/features/language&location/data/languageListTileItemModel.dart';
import 'package:athr/features/language&location/presentation/manager/locale_cubit.dart';
import 'package:athr/features/language&location/presentation/view/location_view.dart';
import 'package:athr/features/language&location/presentation/view/widget/language_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  int currentIndex = 0;

  final List<String> languageCodes = ['ar', 'en', 'fr'];

  final List<Languagelisttileitemmodel> languageListtileitems = [
    Languagelisttileitemmodel(
      title: 'العربية',
      subtitle: 'Arabic',
      countryFlag: AppAssets.sudia,
    ),
    Languagelisttileitemmodel(
      title: "الأنجليزية",
      subtitle: 'English',
      countryFlag: AppAssets.usa,
    ),
    Languagelisttileitemmodel(
      title: 'الفرنسية',
      subtitle: 'French',
      countryFlag: AppAssets.france,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
     clipBehavior: Clip.none,
            children:[ 
               Positioned(
              top: -250,
              right: -190,
              child: drawCircle(
                radius: 170,
                borderColor: Colors.grey.withOpacity(0.08),
                backgroundColor: Color(0xffF5F4F1),
                borderWidth: 5,
              ),
            ),
            Positioned(
              bottom: -250,
              left: -190,
              child: drawCircle(
                radius: 200,
                borderColor: Colors.grey.withOpacity(0.08),
                backgroundColor: Color(0xffF5F4F1),
                borderWidth: 5,
              ),
            ),
           
          
              
              
              
              
              Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                HeaderItem(icone: Icons.language, color: AppColors.primaryColor),
                const Gap(10),
                Text('اختار اللغة', style: AppStyles.styleMedium30(context)),
                const Gap(5),
                Text(
                  'Select Your Preferred Language',
                  textAlign: TextAlign.center,
                  style: AppStyles.styleRegular16(
                    context,
                  ).copyWith(color: Color(0xff6B6B6B)),
                ),
                Gap(20),
                Expanded(
                  child: ListView.builder(
                    itemCount: languageListtileitems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: LanguageListtile(
                            isActive: currentIndex == index,
                            languagelisttileitemmodel:
                                languageListtileitems[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final selectedLanguage = languageCodes[currentIndex];
                  BlocProvider.of<LocaleCubit>(context).changeLanguage(selectedLanguage);// Trigger Cubit
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationView()));
                  },
                  child: Text(
                   'متابعة',
                    style: AppStyles.styleMedium18(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
                Gap(50),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
