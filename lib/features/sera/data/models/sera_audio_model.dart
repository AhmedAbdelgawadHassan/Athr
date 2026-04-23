import 'package:athr/core/utils/app_assets.dart';

class SeraAudioModel {
  final String title;
  final String url;
  String? localPath;
  bool isDownloaded;
  final int number;
  final String image ; 

  SeraAudioModel({
    required this.title,
    required this.url,
    this.localPath,
    this.isDownloaded = false, required this.number, required this.image,
  });



static final  List<SeraAudioModel> seraList = [
  SeraAudioModel(number: 1, title: 'العالم قبل الإسلام', image: AppAssets.beforeIslam, url: 'https://drive.google.com/uc?export=download&id=1qHQHc8Bn3S8wLOaOb8VGwOrueF4lq5Ij'),
  SeraAudioModel(number: 2, title: 'مولد النبي وبداية شبابه', image: AppAssets.mohamedBorn, url: 'https://drive.google.com/uc?export=download&id=14rlgr29dnjM0QI2E2D3VmSDCdhJM6Gy-'),
  SeraAudioModel(number: 3, title: 'وصف النبي ﷺ وزواجه من السيدة خديجة - 01', image: AppAssets.mohamedDesc, url: 'https://drive.google.com/uc?export=download&id=1K_za3fUFdAuw9e5UuySbLfQLRVoIcABY'),
  SeraAudioModel(number: 4, title: 'وصف النبي ﷺ وزواجه من السيدة خديجة - 02', image: AppAssets.khadeja, url: 'https://drive.google.com/uc?export=download&id=1qIdwHTpabqG7_lgOHsUMFvmg6pyEBgcz'),
  SeraAudioModel(number: 5, title: 'نزول الوحي علي النبي والدعوة السرية بمكة', image: AppAssets.wahy, url: 'https://drive.google.com/uc?export=download&id=1nYIyLXV9o2-z9CdzPtYMuxEjv4pvoUPK'),
  SeraAudioModel(number: 6, title: 'بداية الجهر بالدعوة', image: AppAssets.startDawaa, url: 'https://drive.google.com/uc?export=download&id=1-mOM_KG5gxzPGCRcE95lUsqzUlQULTws'),
  SeraAudioModel(number: 7, title: 'بداية فترة استضعاف المسلمين في مكة والهجرة إلي الحبشة', image: AppAssets.hejraToHabasha, url: 'https://drive.google.com/uc?export=download&id=1gkT_kILZD4Yv5pDzgiwThGx_kv09s_CT'),
  SeraAudioModel(number: 8, title: 'إسلام عمر بن الخطاب ووفاة أبو طالب عم النبي', image: AppAssets.omarEbnElKhatab, url: 'https://drive.google.com/uc?export=download&id=1jEptqEumMp2Ro0HvtmSmQr5r6JnSwB56'),
  SeraAudioModel(number: 9, title: 'عام الحزن ورحلة النبي إلي الطائف', image: AppAssets.sadYear, url: 'https://drive.google.com/uc?export=download&id=10siXRa3ZxXRuXwyMgizGk6Q-mOkhdp89'),
  SeraAudioModel(number: 10, title: 'رحلة الإسراء والمعراج', image: AppAssets.esraaAndMearag, url: 'https://drive.google.com/uc?export=download&id=1shkG9-t640rg1IjpUuGHvHpnrBRTYNSu'),
  SeraAudioModel(number: 11, title: 'الطواف علي القبائل وبيعة العقبة الأولي', image: AppAssets.firstOkba, url: 'https://drive.google.com/uc?export=download&id=1BEksczXtr7Q1VGJ2dDWxZavtPjjQT7sm'),
  SeraAudioModel(number: 12, title: 'أحداث الهجرة إلي المدينة', image: AppAssets.hegraToMadenaEvents, url: 'https://drive.google.com/uc?export=download&id=1YIM8ZJ7WzEAM1B4ZtJEalMsJ5DYBOR-N'),
  SeraAudioModel(number: 13, title: 'بداية العهد المدني وتأسيس مدينة للمسلمين', image: AppAssets.muslimsCityBuilding, url: 'https://drive.google.com/uc?export=download&id=1lFVMGzsJocCLfmW5lSsrAiYBTVZjoyS7'),
  SeraAudioModel(number: 14, title: 'مجتمع المدينة ومفهوم الجهاد في سبيل الله', image: AppAssets.jehad, url: 'https://drive.google.com/uc?export=download&id=1j3xa_tXFVOyuVHwvicSlHhk0s8exUV0W'),
  SeraAudioModel(number: 15, title: 'غزوة بدر', image: AppAssets.badr, url: 'https://drive.google.com/uc?export=download&id=1-MEeDCzsUjdSJafEbQQ7BMSkojg6TD4O'),
  SeraAudioModel(number: 16, title: 'أحداث ما بين بدر وأحد', image: AppAssets.eventsBetweenBadr, url: 'https://drive.google.com/uc?export=download&id=1QsdU0I5Z5Rn_z1Mg9h5DksGv7QvJnJpc'),
  SeraAudioModel(number: 17, title: 'غزوة أحد', image: AppAssets.ahod, url: 'https://drive.google.com/uc?export=download&id=1NpFaMmbKU7BUQSADmBy3AL_82YCqHal6'),
  SeraAudioModel(number: 18, title: 'حادثة الإفك', image: AppAssets.efkEvent, url: 'https://drive.google.com/uc?export=download&id=1DJZYKp-NQN2KEZ7ByT8eP1i3tjN2g3jl'),
  SeraAudioModel(number: 19, title: 'غزوة الخندق', image: AppAssets.khandek, url: 'https://drive.google.com/uc?export=download&id=1DfaxOM9bKIPQ9kgqCeeAGZSjzuolMFg5'),
  SeraAudioModel(number: 20, title: 'صلح الحديبية', image: AppAssets.hodaybeya, url: 'https://drive.google.com/uc?export=download&id=1VFPTCyhNUDOMt7SVAPtYN75t-qBHXAYy'),
  SeraAudioModel(number: 21, title: 'غزوة خيبر', image: AppAssets.keybar, url: 'https://drive.google.com/uc?export=download&id=17PKC5DQcLi8LIb_2OxsLYgDA_-FWrn2d'),
  SeraAudioModel(number: 22, title: 'أحداث ما قبل فتح مكة', image: AppAssets.eventsBeforeMakaaOpening, url: 'https://drive.google.com/uc?export=download&id=1qQD7RNqptZOb3YehNO49Ka0Tvy3HMZsv'),
  SeraAudioModel(number: 23, title: 'فتح مكة', image: AppAssets.makaaOpening, url: 'https://drive.google.com/uc?export=download&id=1vdkmoDW4tN6nLxo8By3Cc3jpKJ2c8lRP'),
  SeraAudioModel(number: 24, title: 'غزوة حنين وحصار الطائف', image: AppAssets.hanen, url: 'https://drive.google.com/uc?export=download&id=1_IM7alqudK9rG9CYaDmSDR_LGagUsaA8'),
  SeraAudioModel(number: 25, title: 'غزوة تبوك', image: AppAssets.tabok, url: 'https://drive.google.com/uc?export=download&id=1r6HS6IJ8rmi8ucoAeudmkeFCLfryiwpm'),
  SeraAudioModel(number: 26, title: 'وفاة النبي', image: AppAssets.mohamedDied, url: 'https://drive.google.com/uc?export=download&id=1MzYFameSx9znFg9L-7_A2-lMdTWoru30'),
];
}



// https://drive.google.com/uc?export=download&id=1MzYFameSx9znFg9L-7_A2-lMdTWoru30




