import 'package:athr/core/utils/app_assets.dart';

class Languagelisttileitemmodel {
  final String title;
  final String subtitle;
  final String countryFlag;

  Languagelisttileitemmodel({
    required this.title,
    required this.subtitle,
    required this.countryFlag,
  });


   static  final List<Languagelisttileitemmodel> languageListtileitems = [
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
}
