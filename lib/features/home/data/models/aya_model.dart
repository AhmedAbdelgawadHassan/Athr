class AyahModel {
  final String ayah;
  final String surah;
  final int number;

  AyahModel({
    required this.ayah,
    required this.surah,
    required this.number,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      ayah: json['ayah'],
      surah: json['surah'],
      number: json['number'],
    );
  }
  
}