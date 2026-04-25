class ReminderModel {
  final String id;
  final String title;
  final DateTime time;
  final int color;
  final int icon;
  final bool isDaily;

  ReminderModel({
    required this.id,
    required this.title,
    required this.time,
    required this.color,
    required this.icon,
    required this.isDaily,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'color': color,
      'icon': icon,
      'isDaily': isDaily,
    };
  }

  factory ReminderModel.fromMap(Map<dynamic, dynamic> map) {
    final dynamic rawTime = map['time'];
    final DateTime parsedTime = rawTime is DateTime
        ? rawTime
        : DateTime.tryParse(rawTime?.toString() ?? '') ?? DateTime.now();

    final dynamic rawColor = map['color'];
    final int parsedColor = rawColor is int
        ? rawColor
        : int.tryParse(rawColor?.toString() ?? '') ?? 0xFF4D9F87;

    final dynamic rawIcon = map['icon'];
    final int parsedIcon = rawIcon is int
        ? rawIcon
        : int.tryParse(rawIcon?.toString() ?? '') ?? 0xe318;

    final dynamic rawDaily = map['isDaily'];
    final bool parsedDaily = rawDaily is bool
        ? rawDaily
        : (rawDaily?.toString().toLowerCase() == 'true');

    return ReminderModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      time: parsedTime,
      color: parsedColor,
      icon: parsedIcon,
      isDaily: parsedDaily,
    );
  }
}
